class Company < ApplicationRecord

  has_many :users

  def has_user?(user)
    self == user.company
  end

end
