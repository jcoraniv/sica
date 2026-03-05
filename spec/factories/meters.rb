FactoryBot.define do
  factory :meter do
    sequence(:serial_number) { |n| "MTR-#{1000 + n}" }
    location { "Ubicacion Test" }

    transient do
      meter_zone { create(:zone) }
    end

    zone { meter_zone }
    user { create(:user, zone: meter_zone) }
  end
end
