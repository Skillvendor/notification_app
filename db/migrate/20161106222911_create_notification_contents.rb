class CreateNotificationContents < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_contents do |t|
      t.string :title
      t.text :message_body
      t.integer :send_to, array: true, default: [] 

      t.timestamps
    end
  end
end
