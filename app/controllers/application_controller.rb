class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  before_action :set_locale

  private

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
