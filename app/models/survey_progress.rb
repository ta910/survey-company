class SurveyProgress < ApplicationRecord
  belongs_to :user
  belongs_to :survey
  enum status: { yet: 0, doing:1, done: 2 }
end
