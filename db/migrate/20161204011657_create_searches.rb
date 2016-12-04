class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :first_name
      t.string :last_name
      t.integer :series
      t.integer :year
      t.integer :group_number

      t.timestamps
    end
  end
end
