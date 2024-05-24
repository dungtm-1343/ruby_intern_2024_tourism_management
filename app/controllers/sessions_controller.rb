class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      if user.activated
        handle_activated_user user
      else
        flash[:warning] = t "flash.account.activation_failure"
        redirect_to root_url
      end
    else
      flash.now[:warning] = t "flash.user.login_failure"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def handle_activated_user user
    log_in user
    if params.dig(:session, :remember_me) == Settings.remember_me_checked
      remember(user)
    else
      forget(user)
    end
    flash[:success] = t "flash.user.login_success"
    redirect_to user.role.to_sym == :admin ? admin_path : root_path
  end
end
