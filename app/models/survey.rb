class Survey < ApplicationRecord
  has_many :questions, dependent: :delete_all
  has_one :survey_progress

  class << self
    def create_with_questions!(survey_name:, questions_params:)
      ActiveRecord::Base.transaction do
        survey = Survey.create!(name: survey_name)
        questions_params.each do |question_params|
          Question.create_with_choices!(name: question_params[:name],
           status: question_params[:status], survey_id: survey.id, choices_params: question_params[:choices])
        end
      end
    end

    def create_with_answers!(answer_texts_params:, user:)
      ActiveRecord::Base.transaction do
        if answer_texts_params.present?
          answer_texts_params.each do |answer_text_params|
            AnswerText.create!(text: answer_text_params[:text],
             question_id: answer_text_params[:question_id], user_id: user.id)
          end
        end
        # answer_choices_params.each{ |key, hash|
        #   AnswerChoice.create!
        # }
      end
    end
  end
end
