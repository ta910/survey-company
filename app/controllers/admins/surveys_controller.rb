class Admins::SurveysController < AdminsController
  def index
    @surveys = Survey.order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  def new
    @survey = Survey.new
    @question = Question.new
  end

  def create
    Survey.create_with_questions!(survey_name: survey_params[:name], questions_params: questions_params)
    redirect_to admins_surveys_path
  rescue
    @survey = Survey.new
    @question = Question.new
    render :new
  end

  def destroy
    survey.destroy!
    redirect_to admins_surveys_path
  end

  private

  def index_params
    params.permit(:page).merge(per: 5)
  end

  def survey_params
    params.require(:survey).permit(:name)
  end

  def questions_params
    params.require(:survey).require(:questions).map { |u| u.permit(:name, :status, choices: [%w(name)]) }
  end

  def survey
    Survey.find(params[:id])
  end
end
