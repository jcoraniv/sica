FactoryBot.define do
  factory :payment do
    association :invoice
    association :admin, factory: :user, role: :admin
    amount_paid { invoice.total_amount }
    paid_at { Time.current }
  end
end
