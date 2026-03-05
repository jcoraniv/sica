class PaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find_by(id: invoice_id)
    return if invoice.blank?

    Notification.create!(
      user: invoice.user,
      title: "Pago registrado",
      body: "La factura ##{invoice.id} fue pagada por #{invoice.total_amount}",
      kind: :payment
    )
  end
end
