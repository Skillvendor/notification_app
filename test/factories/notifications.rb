# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    title "MyString"
    body "MyText"
    user_id 1
    expired false
  end
end
