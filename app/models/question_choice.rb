class QuestionChoice < ApplicationRecord
  belongs_to :question
  has_many :users, through: :answer_choices
end
