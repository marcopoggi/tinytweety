class User < ApplicationRecord
  include BCrypt
  attr_accessor :remember_token

  before_save { self.email = email.downcase }

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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    Password.new(remember_digest) == remember_token
  end

  def forget_token
    update_attribute(:remember_digest, nil)
  end

  #Private methods
  private

  def define_empty_fields
    self.email = email_was if email.blank?
    self.name = name_was if name.blank?
  end
end
