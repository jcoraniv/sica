FactoryBot.define do
  factory :zone do
    sequence(:name) { |n| "Zona #{n}" }
    description { "Zona de prueba" }
  end
end
