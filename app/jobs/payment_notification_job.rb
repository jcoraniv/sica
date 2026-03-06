class PaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find_by(id: invoice_id)
    return if invoice.blank?

    Notification.create!(
      user: invoice.user,
      title: I18n.t("jobs.payment_notification.title"),
      body: I18n.t("jobs.payment_notification.body", invoice_id: invoice.id, amount: invoice.total_amount),
      kind: :payment
    )
  end
end
