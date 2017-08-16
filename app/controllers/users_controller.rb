class UsersController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
  before_action :validate_user!, only: :show

  def show
    @user = user
    @users = user.company.normal_users
  end

  def destroy
    user.destroy!
    redirect_to company_users_path(current_user.company.name)
  end
end
