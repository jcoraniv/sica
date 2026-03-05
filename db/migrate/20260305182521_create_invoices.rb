class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :reading, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.text :notes
      t.datetime :issued_at, null: false
      t.datetime :due_at, null: false

      t.timestamps
    end
  end
end
