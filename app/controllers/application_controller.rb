class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #skip_before_action :verify_authenticity_token, if: :json_request?
  #before_action :authenticate_user!
  #before_action :configure_permitted_parameters, if: :devise_controller?
  http_basic_authenticate_with name: "dougs", password: "dougs"

  protected

  def json_request?
    request.format.json?
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
  
end
