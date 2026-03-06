class PaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find_by(id: invoice_id)
    return if invoice.blank?

    Notifications::NotifyPaymentService.call(invoice: invoice)
  end
end
