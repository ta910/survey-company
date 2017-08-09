class Survey < ApplicationRecord
  has_many :questions, dependent: :delete_all

  class << self
    def create_with_questions!(survey_name:, questions_params:)
      ActiveRecord::Base.transaction do
        survey = Survey.create!(name: survey_name)
        questions_params.each do |question_params|
          Question.create!(name: question_params[:name], status: question_params[:status], survey_id: survey.id)
        end
      end
    end
  end
end
