class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    unless current_user.main?
      redirect_to root_path
    else
      user_ids = Company.find_by(name: params[:company_name]).users.ids
      unless user_ids.include?(current_user.id)
        redirect_to root_path
      end
    end
  end

end
