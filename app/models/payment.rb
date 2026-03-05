class Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :admin, class_name: "User", inverse_of: :managed_payments

  validates :amount_paid, numericality: { greater_than: 0 }
  validates :paid_at, presence: true
end
