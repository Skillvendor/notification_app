class AddIsImageToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :is_image, :boolean
  end
end
