class Admins::SurveysController < AdminsController
  def index
    @surveys = Survey.order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
    @company = company
  end

  def new
    @survey = Survey.new
    @question = Question.new
  end

  def create
    Survey.create_with_questions!(survey_name: survey_params[:name], questions_params: questions_params)
    redirect_to admins_companies_path
  rescue
    @survey = Survey.new
    @question = Question.new
    render :new
  end

  def show
    @survey = survey
    @questions = questions
    @company = company
  end

  private

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params[:per] ||= 10
      @index_params
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

    def company
      Company.find_by!(name: params[:company_name])
    end

    def questions
      survey.questions.includes(:question_choices)
    end
end
