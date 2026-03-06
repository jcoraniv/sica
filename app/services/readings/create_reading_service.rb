module Readings
  class CreateReadingService
    def self.call(lecturador:, meter:, current_reading:, read_at:, notes: nil)
      return ServiceResult.failure(errors: [I18n.t("services.readings.create.only_admin_or_reader")]) unless lecturador.admin? || lecturador.lecturador?
      if lecturador.lecturador? && meter.zone_id != lecturador.zone_id
        return ServiceResult.failure(errors: [I18n.t("services.readings.create.meter_outside_zone")])
      end

      user = meter.user
      category = user.category
      return ServiceResult.failure(errors: [I18n.t("services.readings.create.user_category_missing")]) if category.blank?

      previous_reading = meter.readings.order(read_at: :desc).first&.current_reading || 0
      surcharge_percentage = user.usuario? ? category.surcharge_percentage : 0

      calc = Readings::CalculateConsumptionService.call(
        previous_reading: previous_reading,
        current_reading: current_reading,
        price_per_m3: category.price_per_m3,
        surcharge_percentage: surcharge_percentage
      )
      return calc unless calc.success?

      reading = Reading.new(
        meter: meter,
        lecturador: lecturador,
        previous_reading: previous_reading,
        current_reading: current_reading,
        consumption_m3: calc.payload[:consumption_m3],
        read_at: read_at,
        category_name: category.name,
        price_per_m3: category.price_per_m3,
        non_member_surcharge: calc.payload[:non_member_surcharge],
        amount_due: calc.payload[:amount_due],
        notes: notes
      )

      if reading.save
        ActiveSupport::Notifications.instrument("reading.created", reading_id: reading.id)
        ServiceResult.success(payload: { reading: reading })
      else
        ServiceResult.failure(errors: reading.errors.full_messages)
      end
    end
  end
end
