class SurveysController < ApplicationController
  before_action :authenticate_user!, :authorized_user!

  def index
    @surveys = Survey.order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  def answer_new
    @survey = Survey.find(params[:id])
    @questions = @survey.questions.includes(:question_choices)
    @answer_text = AnswerText.new
    @answer_choice = AnswerChoice.new
  end

  def answer_create
    binding.pry
    Survey.create_with_answers!(answer_texts_params, answer_choices_params)
    update_status()
    redirect_to company_surveys_path(current_user.company.name)
  rescue
    @survey = Survey.find(params[:id])
    @questions = @survey.questions.includes(:question_choices)
    @answer_text = AnswerText.new
    @answer_choice = AnswerChoice.new
    render :answer_new
  end

  private

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params = @index_params.merge(per: 5) if params[:per].blank?
      @index_params
    end

    def answer_texts_params
      params.require(:answer_text).tap do |whitelisted|
        whitelisted[:answer_text] = params[:answer_text] if params[:answer_text].is_a?(Hash)
      end
    end

    def answer_choices_params
      params.require(:answer_choice).tap do |whitelisted|
        whitelisted[:answer_choice] = params[:answer_choice] if params[:answer_choice].is_a?(Hash)
      end
    end

  def update_status(user, survey, params)
    if params[:yet].present?
      SurveyProgress.find_or_initialize_by(survey_id: survey.id)
    else
      set_status(user, survey, 1)
    end
  end
end
