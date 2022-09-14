class UsersController < ApplicationController
  before_action(:signup_in_session, only: :new)
  before_action(:logged_in_user, only: [:index, :edit, :update, :destroy])
  before_action(:correct_user, only: [:edit, :update])
  before_action(:admin_user, only: [:destroy])

  def index
    @users = User.order(:name).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in(@user)
      # send activation email
      @user.send_activation_email
      flash[:info] = "Please active your account, check email: #{@user.email})"
      redirect_to root_url
    else
      render :new, status: 403
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit, status: 403
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location #save current url
      flash[:danger] = "Please log in"
      redirect_to login_url, status: 302
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def signup_in_session
    if logged_in?
      flash[:danger] = "Log out to register a new account"
      redirect_to root_url, status: 302
    end
  end
end
