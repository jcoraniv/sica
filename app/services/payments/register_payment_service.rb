module Payments
  class RegisterPaymentService
    def self.call(invoice:, admin:, amount_paid:, paid_at: Time.current)
      return ServiceResult.failure(errors: ["Only admin can register payments"]) unless admin.admin?
      return ServiceResult.failure(errors: ["Invoice already paid"]) if invoice.paid?

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
