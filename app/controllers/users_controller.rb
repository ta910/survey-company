class UsersController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
  before_action :authorized_main!, only: [:index, :destroy]
  before_action :authorized_mypage!, only: :show

  def index
    @users = current_user.company.normal_users
              .order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  def show
    @user = user
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

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params = @index_params.merge(per: 5) if params[:per].blank?
      @index_params
    end

    def user
      User.find(params[:id])
    end
end
