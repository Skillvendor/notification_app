class NotificationContent < ApplicationRecord
  has_many :notifications

  validates :title, presence: true
  validates :message_body, presence: true

  after_create :create_notifications

  mount_uploader :attachment, AttachmentUploader

  def create_notifications
    self.send_to.each do |user_id|
      begin
        notification = Notification.new
        notification.title = self.title
        notification.body = self.message_body
        notification.user_id = user_id
        notification.attachment_url = self.attachment.url
        notification.is_image = %w(jpg jpeg gif png).include?(self.attachment.file.extension.downcase) if self.attachment.file.present?
        notification.notification_content_id = self.id
        notification.save!
      rescue
        puts 'nasol'
      end
    end
  end

end
