class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_token_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent, check your email and follow the instructions"
      redirect_to root_path
    else
      flash.now[:info] = "Email not found"
      render :new, status: 404
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit, status: 400
    elsif @user.update(user_params)
      log_in(@user)
      flash[:success] = "🔒 Password changed"
      redirect_to @user, status: 301
    else
      render :edit, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  def valid_user
    #user should be existent, be activated & enter a valid token
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_token_expiration
    if @user.password_token_reset_expired?
      flash[:info] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end
end
