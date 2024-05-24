class Admin::AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private
  def authenticate_admin!
    return if current_user.role.to_sym == :admin

    flash[:warning] = t "flash.user.access_denied"
    redirect_to root_path
  end
end
