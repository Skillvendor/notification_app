class Notification < ApplicationRecord
  load "#{Rails.root}/lib/ios_push_notification.rb"
  belongs_to :user
  belongs_to :notification_content
  
  validates :title, presence: true
  validates :body, presence: true

  after_create :send_push_notification

  def send_push_notification
    user = self.user
    @service = IosPushNotification.new()
    user.devices.each do |device|
      @service.send_alert_notification(device.token, self.body)
    end
  end
end
