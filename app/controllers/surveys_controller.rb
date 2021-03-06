class SurveysController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
  # before_action :validate_result!, only: :show

  def index
    @surveys = Survey.includes(:survey_progress).order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
    @company = company
  end

  def show
    @survey = survey
    @questions = questions
    @company = company
  end

  def answer_new
    @survey = survey
    @questions = questions
    @answer_choice = AnswerChoice.new
  end

  def answer_create
    ActiveRecord::Base.transaction do
      Survey.create_with_answers!(answer_texts_params: answer_texts_params,
       answer_choices_params: answer_choices_params, user: current_user)
      update_status!
    end
    redirect_to company_surveys_path(current_user.company.name)
  rescue
    @survey = survey
    @questions = questions
    @answer_text = AnswerText.new
    @answer_choice = AnswerChoice.new
    render :answer_new
  end

  def answer_edit
    @survey = survey
    @questions = questions
    @answer_choice = AnswerChoice.new
  end

  def answer_update
    ActiveRecord::Base.transaction do
      survey.update_with_answers!(answer_texts_params: answer_texts_params,
       answer_choices_params: answer_choices_params, user: current_user)
      update_status!
    end
    redirect_to company_surveys_path(current_user.company.name)
  rescue
    @survey = survey
    @questions = questions
    @answer_text = AnswerText.new
    @answer_choice = AnswerChoice.new
    render :answer_edit
  end

  private

    def company
      Company.find_by!(name: params[:company_name])
    end

    def survey
      Survey.find(params[:id])
    end

    def questions
      survey.questions.includes(:question_choices)
    end

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params[:per] ||= 10
      @index_params
    end

    def answer_texts_params
      if params[:answer_text].present?
        params.require(:answer_text).map { |u| u.permit(:text, :question_id) }
      end
    end

    def answer_choices_params
      temporal_params = []
      if params[:answer_choice].present?
        survey.questions.each do |question|
          if params[:answer_choice][:"#{question.id}"].present?
            if array?(question.id)
              temporal_params << params.require(:answer_choice).require(:"#{question.id}").
               permit(:question_id, question_choice_id: [])
            else
              temporal_params << params.require(:answer_choice).require(:"#{question.id}").
               permit(:question_id, :question_choice_id)
              v = temporal_params.last[:question_choice_id]
              temporal_params.last[:question_choice_id] = [v]
            end
          end
        end
      end
      temporal_params
    end

    def array?(question_id)
      params[:answer_choice][:"#{question_id}"][:question_choice_id].kind_of?(Array)
    end

    def update_status!
      if params[:yet].present?
        SurveyProgress.find_or_initialize_by(survey_id: survey.id, user_id: current_user.id).doing!
      elsif params[:done].present?
        SurveyProgress.find_or_initialize_by(survey_id: survey.id, user_id: current_user.id).done!
      else
        raise
      end
    end

    def validate_result!
      if SurveyProgress.find_by(survey_id: survey.id, user: current_user).present?
        progress = SurveyProgress.find_by(survey_id: survey.id, user: current_user)
        raise ActionController::BadRequest if progress.status == 'doing'
      else
        raise ActionController::BadRequest
      end
    end

    def validate_new!
      raise ActionController::BadRequest if SurveyProgress.find_by(survey_id: survey.id, user_id: user.id).present?
    end
end
