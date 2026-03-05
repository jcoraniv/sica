class AddForeignKeysToUsers < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :users, :zones
    add_foreign_key :users, :categories
  end
end
