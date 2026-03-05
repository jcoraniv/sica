FactoryBot.define do
  factory :notification do
    association :user
    title { "Notificacion de prueba" }
    body { "Contenido de prueba" }
    kind { :reading }
    read_at { nil }
  end
end
