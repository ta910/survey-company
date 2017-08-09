class Question < ApplicationRecord
  belongs_to :survey
  has_many :question_choices, dependent: :delete_all
  enum status: { text_field: 0, textarea: 1, radio_button: 2, check_box: 3 }
end
