class Admins::SurveysController < AdminsController
  def index
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