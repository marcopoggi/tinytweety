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
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #search user & verify the signed token in the cookie
      user = User.find_by(id: user_id)
      #User Model method
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget_token #reset attribute remember_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(other_path = "/")
    redirect_to(session[:destination_url] || other_path)
    session.delete(:destination_url) if request.original_url == session[:destination_url]
  end

  def store_location
    session[:destination_url] = request.url if request.get?
  end
end
