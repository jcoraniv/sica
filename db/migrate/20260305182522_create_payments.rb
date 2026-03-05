class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.decimal :amount_paid, precision: 10, scale: 2, null: false
      t.datetime :paid_at, null: false

      t.timestamps
    end
  end
end
