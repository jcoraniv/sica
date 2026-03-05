class CreateReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :readings do |t|
      t.references :meter, null: false, foreign_key: true
      t.references :lecturador, null: false, foreign_key: { to_table: :users }
      t.decimal :previous_reading, precision: 10, scale: 2, null: false
      t.decimal :current_reading, precision: 10, scale: 2, null: false
      t.decimal :consumption_m3, precision: 10, scale: 2, null: false, default: 0
      t.datetime :read_at, null: false
      t.string :category_name, null: false
      t.decimal :price_per_m3, precision: 10, scale: 2, null: false
      t.decimal :non_member_surcharge, precision: 10, scale: 2, null: false, default: 0
      t.decimal :amount_due, precision: 10, scale: 2, null: false, default: 0
      t.text :notes

      t.timestamps
    end

    add_index :readings, %i[meter_id read_at]
  end
end
