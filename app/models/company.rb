class Company < ApplicationRecord

  has_many :users
  accepts_nested_attributes_for :users

  def has_user?(user)
    self == user.company
  end

end
