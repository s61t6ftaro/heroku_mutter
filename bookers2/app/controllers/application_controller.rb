class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if current_user
      flash[:notice] = 'Signed in successfully' 
      user_path(resource)
    else
      user_path(resource)
      flash[:notice] = 'Welcome! You have signed up successfully.'
    end
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = 'Signed out successfully.' 
    root_path(resource)
  end 

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  
protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])    
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])    
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end