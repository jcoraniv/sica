module Payments
  class RegisterPaymentService
    def self.call(invoice:, admin:, amount_paid:, paid_at: Time.current)
      return ServiceResult.failure(errors: [I18n.t("services.payments.register.only_admin")]) unless admin.admin?
      return ServiceResult.failure(errors: [I18n.t("services.payments.register.invoice_already_paid")]) if invoice.paid?

      payment = Payment.new(invoice: invoice, admin: admin, amount_paid: amount_paid, paid_at: paid_at)

      ActiveRecord::Base.transaction do
        payment.save!
        invoice.update!(status: :paid)
      end

      ActiveSupport::Notifications.instrument("invoice.paid", invoice_id: invoice.id)
      ServiceResult.success(payload: { payment: payment, invoice: invoice })
    rescue ActiveRecord::RecordInvalid => e
      ServiceResult.failure(errors: e.record.errors.full_messages)
    end
  end
end
