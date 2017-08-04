class Company < ApplicationRecord

  has_many :users, dependent: :delete_all
  accepts_nested_attributes_for :users

  def has_user?(user)
    self == user.company
  end

  def main_user!
    users.main.first
  end

end
