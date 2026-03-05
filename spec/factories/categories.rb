FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    price_per_m3 { 7.5 }
    surcharge_percentage { 10.0 }
  end
end
