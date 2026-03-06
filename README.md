# SICA - Potable Water Consumption Control System

Rails application built with a Clean Architecture + AI-First approach to register meter readings, generate invoices/PDFs, process payments, and trigger automatic notifications.

## Stack

- Ruby 3.3 / Rails 8.0 (compatible with the requested Rails 7.x architecture style)
- PostgreSQL
- Devise (authentication)
- Pundit (authorization)
- Sidekiq (background jobs)
- Prawn (PDF generation)
- Chartkick + Groupdate (dashboard charts)
- RSpec + FactoryBot (testing)

## Architecture

- `app/services/**`: use cases (single source of business logic)
- `app/controllers/**`: request delegation + HTTP response
- `app/models/**`: associations, validations, scopes
- `app/jobs/**`: asynchronous tasks
- `app/policies/**`: authorization rules
- `app/pdfs/**`: PDF entry points

### Implemented Services

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

All services return `ServiceResult` (`success?`, `payload`, `errors`).

## Covered Business Rules

- Price/category snapshot is stored in `Reading`.
- Surcharge applies only to `usuario` role.
- Minimum billable consumption: `0`.
- A `lecturador` can only register readings in their assigned zone.
- `Reading` can be edited only while related `Invoice` is still `pending`.
- `Invoice` with status `paid` is immutable.
- Notifications are event-driven (`ActiveSupport::Notifications` + jobs).

## JSON API Endpoints

Base path: `/api/v1`

- `POST /readings` create reading
- `PATCH /readings/:id` update reading
- `POST /invoices` generate invoice
- `GET /invoices/:id/pdf` retrieve invoice PDF
- `POST /payments` register payment
- `PATCH /users/:id/assign_zone` assign zone
- `PATCH /users/:id/assign_category` assign category
- `POST /meetings/notify` send meeting notification to members

## Getting Started

```bash
bundle install
bundle exec rails db:create db:migrate db:seed
bundle exec rails server
```

Sidekiq:

```bash
bundle exec sidekiq
```

## Seed Credentials

- Admin: `admin` / `password123`
- Reader (`lecturador`): `lecturador` / `password123`
- Member (`socio`): `socio` / `password123`
- User (`usuario`): `usuario` / `password123`

## Railway

Minimum required environment variables:

- `RAILS_MASTER_KEY`
- `DATABASE_URL`
- `REDIS_URL`
- `RAILS_ENV=production`
- `GOOGLE_MAPS_API_KEY` (for zone meter map)
- `NOTIFICATIONS_BACKEND` (optional: `inline`, `active_job`, `web_push`, `null`; default `web_push`)
- `WEB_PUSH_VAPID_PUBLIC_KEY`
- `WEB_PUSH_VAPID_PRIVATE_KEY`
- `WEB_PUSH_VAPID_SUBJECT` (example: `mailto:admin@yourdomain.com`)

## CI/CD

GitHub Actions workflow at `.github/workflows/ci.yml` includes:

- Brakeman
- Bundler Audit
- RuboCop
- RSpec (with PostgreSQL service)
