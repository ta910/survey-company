class UsersController < ApplicationController

  before_action :authenticate_admin_or_user

  def index
    unless current_user.main?
      redirect_to root_path
    end
  end

end
