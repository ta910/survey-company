class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  validates :company_id, uniqueness: true, if: 'main?'
  enum status: { normal: 0, main: 1 }
  mount_uploader :image, ImagesUploader
end
