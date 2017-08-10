class Company < ApplicationRecord
  has_many :users, dependent: :delete_all
  validates :name, uniqueness: true

  def has_user?(user)
    self == user.company
  end

  def main_user
    users.main.first
  end

  def normal_users
    users.normal
  end

  def update_with_main_user!(company_name:, user_name:, email:, password:, password_confirmation:)
    ActiveRecord::Base.transaction do
      update!(name: company_name)
      main_user.update!(name: user_name, email: email,
           password: password, password_confirmation: password_confirmation)
    end
  end

  class << self
    def create_with_main_user!(company_name:, user_name:, email:, password:, password_confirmation:)
      ActiveRecord::Base.transaction do
        company = Company.create!(name: company_name)
        User.create!(name: user_name, email: email,
           password: password, password_confirmation: password_confirmation, company_id: company.id, status: "main")
      end
    end
  end
end
