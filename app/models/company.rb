class Company < ApplicationRecord

  has_many :users

  def has_user?(user)
    true if self == user.company
  end

end
