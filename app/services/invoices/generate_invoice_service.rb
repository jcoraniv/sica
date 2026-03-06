module Invoices
  class GenerateInvoiceService
    DEFAULT_DUE_DAYS = 30

    def self.call(reading:, due_days: DEFAULT_DUE_DAYS)
      invoice = reading.invoice || Invoice.new(reading: reading, user: reading.meter.user)
      return ServiceResult.failure(errors: [I18n.t("services.invoices.generate.paid_immutable")]) if invoice.persisted? && invoice.paid?

      now = Time.current
      invoice.assign_attributes(
        total_amount: reading.amount_due,
        status: :pending,
        issued_at: invoice.issued_at || now,
        due_at: invoice.due_at || (now + due_days.days)
      )

      if invoice.save
        ServiceResult.success(payload: { invoice: invoice })
      else
        ServiceResult.failure(errors: invoice.errors.full_messages)
      end
    end
  end
end
