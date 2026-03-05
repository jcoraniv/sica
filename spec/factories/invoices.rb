FactoryBot.define do
  factory :invoice do
    association :reading
    user { reading.meter.user }
    total_amount { reading.amount_due }
    status { :pending }
    notes { "Factura de prueba" }
    issued_at { Time.current }
    due_at { 30.days.from_now }
  end
end
