# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  
  # GET /resource/sign_in
  # def new
  # end
  flash[:alert] ="ユーザ名、パスワードが一致しません"

  # POST /resource/sign_in
  # def create  
  # end

  # DELETE /resource
  # def destroy
    
  # end
  
  # def after_sign_in_path_for(resource)
  # end 

  #ログアウト後のリダイレクト先
  # def after_sign_out_path_for(resource)
  # end 


  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
