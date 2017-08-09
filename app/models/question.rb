class Question < ApplicationRecord
  belongs_to :survey
  has_many :question_choices, dependent: :delete_all
  enum status: { text_field: 0, textarea: 1, radio_button: 2, check_box: 3 }

  class << self
    def create_with_choices!(name:, status:, survey_id:, choices_params:)
      ActiveRecord::Base.transaction do
        question = create!(name: name, status: status, survey_id: survey_id)
        if choices_params.present?
          choices_params.each do |choice_params|
            QuestionChoice.create!(text: choice_params[:name], question_id: question.id)
          end
        end
      end
    end
  end
end
