FactoryGirl.define do
  factory :question do
    name Faker::Name.name
    status 2
  end
end