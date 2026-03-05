class CreateMeters < ActiveRecord::Migration[8.0]
  def change
    create_table :meters do |t|
      t.string :serial_number, null: false
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.references :zone, null: false, foreign_key: true

      t.timestamps
    end

    add_index :meters, :serial_number, unique: true
  end
end
