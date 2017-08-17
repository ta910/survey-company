class Survey < ApplicationRecord
  has_many :questions, dependent: :delete_all

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

    def create_with_answers!(answer_texts_params:, answer_choices_params:)
      ActiveRecord::Base.transaction do
        answer_texts_params.each{ |key, hash|
          AnswerText.create!(text: hash[:text], user_id: current_user.id, question_id: key)
        } if answer_texts_params.present?
        end
      end
    end
  end
end
