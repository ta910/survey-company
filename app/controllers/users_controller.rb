class UsersController < ApplicationController
  before_action :authenticate_user!, :authorized_main!, :authorized_user!

  def index
    @users = current_user.company.users.normal
              .order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  def destroy
    user.destroy!
    redirect_to company_users_path(current_user.company.name)
  end

  private

    def authorized_main!
      redirect_to root_path unless current_user.main?
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
