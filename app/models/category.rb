class Category < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :price_per_m3, numericality: { greater_than_or_equal_to: 0 }
  validates :surcharge_percentage, numericality: { greater_than_or_equal_to: 0 }
end
