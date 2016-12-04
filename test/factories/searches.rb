# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search do
    first_name "MyString"
    last_name "MyString"
    series 1
    year 1
    group_number 1
  end
end
