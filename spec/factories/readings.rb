FactoryBot.define do
  factory :reading do
    transient do
      reading_meter { create(:meter) }
    end

    meter { reading_meter }
    lecturador { create(:user, :lecturador, zone: meter.zone) }
    previous_reading { 10.0 }
    current_reading { 15.0 }
    consumption_m3 { 5.0 }
    read_at { Time.current }
    category_name { meter.user.category.name }
    price_per_m3 { meter.user.category.price_per_m3 }
    non_member_surcharge { 0 }
    amount_due { 37.5 }
    notes { "Lectura mensual" }
  end
end
