class Survey < ApplicationRecord
  has_many :questions, dependent: :delete_all
  has_one :survey_progress

  def update_with_answers!(answer_texts_params:, answer_choices_params:, user:)
    ActiveRecord::Base.transaction do
      update_answer_text!(answer_texts_params: answer_texts_params, user: user) if answer_texts_params.present?
      delete_pre_choices(user: user)
      create_answer_choice!(answer_choices_params: answer_choices_params, user: user) if answer_choices_params.present?
    end
  end

  private

    def create_answer_text!(answer_texts_params:, user:)
      answer_texts_params.each do |answer_text_params|
        AnswerText.create!(text: answer_text_params[:text],
         question_id: answer_text_params[:question_id], user_id: user.id)
      end
    end

    def update_answer_text!(answer_texts_params:, user:)
      answer_texts_params.each do |answer_text_params|
        answer_text = AnswerText.find_by!(question_id: answer_text_params[:question_id], user_id: user.id)
        answer_text.update!(text: answer_text_params[:text])
      end
    end

    def create_answer_choice!(answer_choices_params:, user:)
      answer_choices_params.each do |answer_choice_params|
        answer_choice_params[:question_choice_id].each do |question_choice_id|
          AnswerChoice.create!(question_choice_id: question_choice_id, user_id: user.id)
        end
      end
    end

    def delete_pre_choices(user:)
      question_choices = QuestionChoice.where(question_id: questions.includes(:question_choices).ids)
      answer_choices = AnswerChoice.where(question_choice: question_choices, user: user)
      answer_choices.destroy_all
    end

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

    def create_with_answers!(answer_texts_params:, answer_choices_params:, user:)
      ActiveRecord::Base.transaction do
        create_answer_text!(answer_texts_params: answer_texts_params, user: user) if answer_texts_params.present?
        create_answer_choice!(answer_choices_params: answer_choices_params, user: user) if answer_choices_params.present?
      end
    end

    private

      def create_answer_text!(answer_texts_params:, user:)
        answer_texts_params.each do |answer_text_params|
          AnswerText.create!(text: answer_text_params[:text],
           question_id: answer_text_params[:question_id], user_id: user.id)
        end
      end

      def create_answer_choice!(answer_choices_params:, user:)
        answer_choices_params.each do |answer_choice_params|
          answer_choice_params[:question_choice_id].each do |question_choice_id|
            AnswerChoice.create!(question_choice_id: question_choice_id, user_id: user.id)
          end
        end
      end
  end
end
