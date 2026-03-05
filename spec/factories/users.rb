FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@sica.local" }
    password { "password123" }
    password_confirmation { "password123" }
    name { "Usuario Test" }
    phone { "70000000" }
    address { "Direccion Test" }
    role { :usuario }
    association :zone
    association :category

    trait :admin do
      role { :admin }
    end

    trait :lecturador do
      role { :lecturador }
    end

    trait :socio do
      role { :socio }
    end
  end
end
