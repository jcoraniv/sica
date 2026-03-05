require "rails_helper"

RSpec.describe Readings::CalculateConsumptionService do
  describe ".call" do
    it "calcula consumo, recargo y monto total" do
      result = described_class.call(
        previous_reading: 10,
        current_reading: 20,
        price_per_m3: 5,
        surcharge_percentage: 10
      )

      expect(result).to be_success
      expect(result.payload[:consumption_m3]).to eq(10)
      expect(result.payload[:non_member_surcharge]).to eq(5)
      expect(result.payload[:amount_due]).to eq(55)
    end

    it "aplica consumo minimo facturable de 0" do
      result = described_class.call(
        previous_reading: 20,
        current_reading: 10,
        price_per_m3: 5,
        surcharge_percentage: 10
      )

      expect(result).to be_success
      expect(result.payload[:consumption_m3]).to eq(0)
      expect(result.payload[:amount_due]).to eq(0)
    end
  end
end
