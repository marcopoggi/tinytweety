class User < ApplicationRecord
  include BCrypt
  attr_accessor :remember_token, :activation_token

  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  #in case email or name has blank
  before_validation :define_empty_fields, on: :update

  VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 256 },
                    format: { with: VALID_EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8, maximum: 512 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? Engine::MIN_COST : Engine.cost
    Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #return true if token matches with remember_digest
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    Password.new(digest) == token
  end

  def forget_token
    update_attribute(:remember_digest, nil)
  end

  #activate account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  #send activation
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #Private methods
  private

  def define_empty_fields
    self.email = email_was if email.blank?
    self.name = name_was if name.blank?
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
