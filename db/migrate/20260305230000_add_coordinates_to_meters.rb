class AddCoordinatesToMeters < ActiveRecord::Migration[8.0]
  def change
    add_column :meters, :latitude, :decimal, precision: 10, scale: 6
    add_column :meters, :longitude, :decimal, precision: 10, scale: 6
    add_index :meters, %i[latitude longitude]
  end
end
