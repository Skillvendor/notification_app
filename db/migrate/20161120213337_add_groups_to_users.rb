class AddGroupsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :groups, :json, default: {}
  end
end
