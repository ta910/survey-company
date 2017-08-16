class SurveysController < ApplicationController
  before_action :authenticate_user!, :authorized_user!

  def index
    @surveys = Survey.order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  private

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params = @index_params.merge(per: 5) if params[:per].blank?
      @index_params
    end
end
