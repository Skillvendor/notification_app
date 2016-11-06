class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notification_content
  
  validates :title, presence: true
  validates :message_body, presence: true
  validates :send_to, presence: true
end
