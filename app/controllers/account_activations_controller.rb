class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "flash.account.activation_success"
      redirect_to user
    else
      flash[:danger] = t "flash.account.activation_failure"
      redirect_to root_url
    end
  end
end
