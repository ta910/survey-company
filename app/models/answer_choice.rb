class AnswerChoice < ApplicationRecord
  belongs_to :user
  belongs_to :question_choice
end
