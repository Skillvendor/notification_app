# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_content do
    title "MyString"
    message_body "MyText"
    send_to 1
  end
end
