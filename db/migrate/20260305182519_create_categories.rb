class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.decimal :price_per_m3, precision: 10, scale: 2, null: false
      t.decimal :surcharge_percentage, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
