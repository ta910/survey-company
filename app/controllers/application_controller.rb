class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admins_companies_path
    when User
      if current_user.normal?
        company_surveys_path(current_user.company.name)
      elsif current_user.main?
        company_users_path(current_user.company.name)
      else
        root_path
      end
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :company_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:company_id])
  end

end
