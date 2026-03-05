# SICA - Sistema de Control de Consumo de Agua Potable

Aplicación Rails orientada a Clean Architecture + AI-First para registrar lecturas, generar facturas/PDF, cobrar pagos y notificar automáticamente.

## Stack

- Ruby 3.3 / Rails 8.0 (compatible con el diseño solicitado para Rails 7.x)
- PostgreSQL
- Devise (autenticación)
- Pundit (autorización)
- Sidekiq (jobs)
- Prawn (PDF)
- Chartkick + Groupdate (dashboard)
- RSpec + FactoryBot (testing)

## Arquitectura

- `app/services/**`: casos de uso (única lógica de negocio)
- `app/controllers/**`: delegación a services + respuesta HTTP
- `app/models/**`: asociaciones, validaciones, scopes
- `app/jobs/**`: tareas asíncronas
- `app/policies/**`: reglas de autorización
- `app/pdfs/**`: punto de entrada PDF

### Services implementados

- `readings/create_reading_service.rb`
- `readings/update_reading_service.rb`
- `readings/calculate_consumption_service.rb`
- `invoices/generate_invoice_service.rb`
- `invoices/generate_pdf_service.rb`
- `payments/register_payment_service.rb`
- `notifications/notify_reading_service.rb`
- `notifications/notify_meeting_service.rb`
- `users/assign_zone_service.rb`
- `users/assign_category_service.rb`

Todos retornan `ServiceResult` (`success?`, `payload`, `errors`).

## Reglas de negocio cubiertas

- Snapshot de precio/categoría en `Reading`.
- Recargo solo para rol `usuario`.
- Consumo mínimo facturable: `0`.
- Lecturador solo registra lecturas en su zona.
- `Reading` editable solo si `Invoice` sigue `pending`.
- `Invoice` `paid` se considera inmutable.
- Notificaciones disparadas por eventos (`ActiveSupport::Notifications` + jobs).

## Endpoints API (JSON)

Base: `/api/v1`

- `POST /readings` crear lectura
- `PATCH /readings/:id` actualizar lectura
- `POST /invoices` generar factura
- `GET /invoices/:id/pdf` obtener boleta PDF
- `POST /payments` registrar pago
- `PATCH /users/:id/assign_zone` asignar zona
- `PATCH /users/:id/assign_category` asignar categoría
- `POST /meetings/notify` notificación de reunión a socios

## Puesta en marcha

```bash
bundle install
bundle exec rails db:create db:migrate db:seed
bundle exec rails server
```

Sidekiq:

```bash
bundle exec sidekiq
```

## Credenciales seed

- Admin: `admin` / `password123`
- Lecturador: `lecturador` / `password123`
- Socio: `socio` / `password123`
- Usuario: `usuario` / `password123`

## Railway

Variables mínimas:

- `RAILS_MASTER_KEY`
- `DATABASE_URL`
- `REDIS_URL`
- `RAILS_ENV=production`
- `GOOGLE_MAPS_API_KEY` (para mapa de medidores por zona)

## CI/CD

Workflow GitHub Actions en `.github/workflows/ci.yml`:

- Brakeman
- Bundler Audit
- RuboCop
- RSpec (con servicio PostgreSQL)
