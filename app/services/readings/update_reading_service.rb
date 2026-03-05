module Readings
  class UpdateReadingService
    def self.call(reading:, current_reading:, read_at:, notes: nil)
      if reading.invoice&.paid?
        return ServiceResult.failure(errors: ["Reading cannot be modified because invoice is paid"])
      end

      category_price = reading.price_per_m3
      base_amount = [BigDecimal(current_reading.to_s) - BigDecimal(reading.previous_reading.to_s), 0].max * BigDecimal(category_price.to_s)
      surcharge_percentage = if base_amount.zero?
                               0
                             else
                               (BigDecimal(reading.non_member_surcharge.to_s) / base_amount) * 100
                             end

      calc = Readings::CalculateConsumptionService.call(
        previous_reading: reading.previous_reading,
        current_reading: current_reading,
        price_per_m3: reading.price_per_m3,
        surcharge_percentage: surcharge_percentage
      )
      return calc unless calc.success?

      attrs = {
        current_reading: current_reading,
        read_at: read_at,
        notes: notes,
        consumption_m3: calc.payload[:consumption_m3],
        non_member_surcharge: calc.payload[:non_member_surcharge],
        amount_due: calc.payload[:amount_due]
      }

      if reading.update(attrs)
        reading.invoice&.update(total_amount: reading.amount_due)
        ServiceResult.success(payload: { reading: reading })
      else
        ServiceResult.failure(errors: reading.errors.full_messages)
      end
    end
  end
end
