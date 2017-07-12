class UsersController < ApplicationController

  def index
    unless current_user.main?
      redirect_to root_path
    end
  end

end
