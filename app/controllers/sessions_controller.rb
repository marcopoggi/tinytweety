class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      #redirect to user profile
      redirect_to user
    else
      #display invalid credentials message
      flash.now[:danger] = "Invalid email or password"
      render :new, status: 401
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: 303
  end
end
