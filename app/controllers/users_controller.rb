class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user.not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.account.check_email_to_activate"
      redirect_to login_url
    else
      handle_failed_signup
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES
  end

  def handle_failed_signup
    flash.now[:danger] = t "flash.user.signup_failure"
    render :new, status: :unprocessable_entity
  end
end
