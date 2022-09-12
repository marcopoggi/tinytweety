class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
                                                                    #token
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in(user)
      flash[:success] = "Welcome to TinyTweety"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_path
    end
  end
end
