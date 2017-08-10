class UsersController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
  before_action :authorized_main!, only: [:destroy]
  before_action :authorized_mypage!, only: :show

  def show
    @user = user
    @users = user.company.normal_users
  end

  def destroy
    user.destroy!
    redirect_to company_users_path(current_user.company.name)
  end

  private

    def authorized_main!
      redirect_to root_path unless current_user.main?
    end

    def authorized_mypage!
      redirect_to root_path if current_user != user && current_user.normal?
    end

    def user
      User.find(params[:id])
    end
end
