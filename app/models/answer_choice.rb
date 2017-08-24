class AnswerChoice < ApplicationRecord
  belongs_to :user
  belongs_to :question_choice
  validates :user_id, uniqueness: {scope: [:question_choice_id]}
end
