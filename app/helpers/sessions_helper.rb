module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  #remember user in a persistent session
  def remember(user)
    #call remember method in User model
    user.remember #set remember_token virtual field with a new token (BASE64)

    #signing the cookie
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
