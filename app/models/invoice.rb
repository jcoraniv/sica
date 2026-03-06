class Invoice < ApplicationRecord
  belongs_to :reading
  belongs_to :user
  has_many :payments, dependent: :restrict_with_exception

  enum :status, { pending: 0, paid: 1 }

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :issued_at, :due_at, presence: true
  validate :immutable_when_paid, on: :update

  private

  def immutable_when_paid
    return unless status_in_database == "paid" && changed?

    errors.add(:base, I18n.t("models.invoice.errors.paid_immutable"))
  end
end
