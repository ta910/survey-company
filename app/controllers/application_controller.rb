class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admins_companies_path
    when User
      company_user_path(current_user.company.name, current_user)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  rescue_from ActionController::BadRequest do |e|
    redirect_to root_path
  end

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :company_id])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :image])
    end

    def authorized_user!
      company = Company.find_by!(name: params[:company_name])
      raise ActionController::BadRequest unless company.has_user?(current_user)
    end

    def validate_user!
      raise ActionController::BadRequest if current_user != user && current_user.normal?
    end

    def user
      User.find(params[:id])
    end
end
