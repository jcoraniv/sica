class Meter < ApplicationRecord
  belongs_to :user
  belongs_to :zone
  has_many :readings, dependent: :restrict_with_exception

  validates :serial_number, presence: true, uniqueness: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
  validate :zone_matches_user_zone
  validate :coordinates_presence_together

  private

  def zone_matches_user_zone
    return if user.blank? || zone.blank? || user.zone_id.blank?
    return if user.zone_id == zone_id

    errors.add(:zone_id, I18n.t("models.meter.errors.zone_must_match_user_zone"))
  end

  def coordinates_presence_together
    return if latitude.present? && longitude.present?
    return if latitude.blank? && longitude.blank?

    errors.add(:base, I18n.t("models.meter.errors.coordinates_presence_together"))
  end
end
