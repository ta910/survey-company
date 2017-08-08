class SurveysController < ApplicationController
  before_action :authenticate_user!, :authorized_user!

  def index
    @surveys = Survey.order(created_at: 'DESC')
  end

  def new
    @survey = Survey.new
  end

  def create
    
  end

  private

  def survey_params

  end
end
