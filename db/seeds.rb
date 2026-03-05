zone_centro = Zone.find_or_create_by!(name: "Centro") do |z|
  z.description = "Zona central de la comunidad"
end

zone_norte = Zone.find_or_create_by!(name: "Norte") do |z|
  z.description = "Zona norte"
end

cat_domestico = Category.find_or_create_by!(name: "Domestico") do |c|
  c.price_per_m3 = 6.50
  c.surcharge_percentage = 0
end

cat_general = Category.find_or_create_by!(name: "General") do |c|
  c.price_per_m3 = 7.20
  c.surcharge_percentage = 12.5
end

admin = User.find_or_initialize_by(email: "admin@sica.local")
admin.assign_attributes(
  username: "admin",
  password: "password123",
  password_confirmation: "password123",
  name: "Admin SICA",
  phone: "70000001",
  address: "Oficina Central",
  role: :admin,
  zone: zone_centro,
  category: cat_domestico
)
admin.save!

lecturador = User.find_or_initialize_by(email: "lecturador@sica.local")
lecturador.assign_attributes(
  username: "lecturador",
  password: "password123",
  password_confirmation: "password123",
  name: "Lecturador Norte",
  phone: "70000002",
  address: "Zona Norte",
  role: :lecturador,
  zone: zone_norte,
  category: cat_domestico
)
lecturador.save!

socio = User.find_or_initialize_by(email: "socio@sica.local")
socio.assign_attributes(
  username: "socio",
  password: "password123",
  password_confirmation: "password123",
  name: "Socio Ejemplo",
  phone: "70000003",
  address: "Calle 1",
  role: :socio,
  zone: zone_norte,
  category: cat_domestico
)
socio.save!

usuario = User.find_or_initialize_by(email: "usuario@sica.local")
usuario.assign_attributes(
  username: "usuario",
  password: "password123",
  password_confirmation: "password123",
  name: "Usuario No Socio",
  phone: "70000004",
  address: "Calle 2",
  role: :usuario,
  zone: zone_norte,
  category: cat_general
)
usuario.save!

Meter.find_or_create_by!(serial_number: "MTR-1001") do |m|
  m.location = "Ingreso Norte"
  m.user = socio
  m.zone = zone_norte
end

Meter.find_or_create_by!(serial_number: "MTR-1002") do |m|
  m.location = "Pasaje 3"
  m.user = usuario
  m.zone = zone_norte
end
