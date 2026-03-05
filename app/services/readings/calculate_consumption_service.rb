module Readings
  class CalculateConsumptionService
    def self.call(previous_reading:, current_reading:, price_per_m3:, surcharge_percentage:)
      previous = BigDecimal(previous_reading.to_s)
      current = BigDecimal(current_reading.to_s)
      unit_price = BigDecimal(price_per_m3.to_s)
      surcharge_pct = BigDecimal(surcharge_percentage.to_s)

      consumption = [current - previous, 0].max
      base_amount = consumption * unit_price
      surcharge_amount = base_amount * (surcharge_pct / 100)
      total_amount = base_amount + surcharge_amount

      ServiceResult.success(
        payload: {
          consumption_m3: consumption.round(2),
          non_member_surcharge: surcharge_amount.round(2),
          amount_due: total_amount.round(2)
        }
      )
    rescue StandardError => e
      ServiceResult.failure(errors: [e.message])
    end
  end
end
