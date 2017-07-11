class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admins_companies_path
    when User
      if current_user.normal?
        company_surveys_path
      else
        mains_users_path
      end
    end
  end
end
