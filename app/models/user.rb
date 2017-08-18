class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :messages
  has_many :answer_texts
  has_many :question_choices, through: :answer_choices
  has_many :survey_progresses
  belongs_to :company
  enum status: { normal: 0, main: 1 }
  mount_uploader :image, ImagesUploader
end
