class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :avatar) }
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
  end
end
