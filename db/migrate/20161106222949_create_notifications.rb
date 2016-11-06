class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.boolean :expired, default: false

      t.timestamps
    end
  end
end
