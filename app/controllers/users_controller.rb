class UsersController < ApplicationController
  before_action :authenticate_user!, :authorized_main!, :authorized_user!

  def index
  end

  private

    def authorized_main!
      redirect_to root_path unless current_user.main?
    end
end
