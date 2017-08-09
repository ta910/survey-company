class Survey < ApplicationRecord
  has_many :questions, dependent: :delete_all

  class << self
    def create_with_questions!(survey_name:, questions_params:)
      ActiveRecord::Base.transaction do
        survey = Survey.create!(name: survey_name)
        questions_params.each do |question_params|
          question = Question.create!(name: question_params[:name], status: question_params[:status], survey_id: survey.id)
          if question_params[:choices].present?
            question_params[:choices].each do |choice_params|
              QuestionChoice.create!(text: choice_params[:name], question_id: question.id)
            end
          end
        end
      end
    end
  end
end
