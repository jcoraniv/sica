class Reading < ApplicationRecord
  belongs_to :meter
  belongs_to :lecturador, class_name: "User", inverse_of: :readings
  has_one :invoice, dependent: :restrict_with_exception

  validates :previous_reading, :current_reading, :consumption_m3, :price_per_m3, :non_member_surcharge, :amount_due,
            numericality: { greater_than_or_equal_to: 0 }
  validates :category_name, :read_at, presence: true
  validate :current_reading_not_below_previous

  private

  def current_reading_not_below_previous
    return if current_reading.blank? || previous_reading.blank?
    return if current_reading >= previous_reading

    errors.add(:current_reading, "must be greater than or equal to previous_reading")
  end
end
