class AddAttachmentToNotificationContent < ActiveRecord::Migration[5.0]
  def change
    add_column :notification_contents, :attachment, :string
  end
end
