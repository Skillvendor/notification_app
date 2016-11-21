class AddTokenToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :token, :string
  end
end
