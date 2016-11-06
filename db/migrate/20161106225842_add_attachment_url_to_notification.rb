class AddAttachmentUrlToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :attachment_url, :string
  end
end
