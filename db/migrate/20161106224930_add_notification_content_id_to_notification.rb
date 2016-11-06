class AddNotificationContentIdToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :notification_content_id, :integer
  end
end
