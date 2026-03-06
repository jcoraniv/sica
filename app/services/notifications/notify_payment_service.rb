module Notifications
  class NotifyPaymentService
    def self.call(invoice:)
      notification = Notification.new(
        user: invoice.user,
        title: I18n.t("jobs.payment_notification.title"),
        body: I18n.t("jobs.payment_notification.body", invoice_id: invoice.id, amount: invoice.total_amount),
        kind: :payment
      )

      if notification.save
        ServiceResult.success(payload: { notification: notification })
      else
        ServiceResult.failure(errors: notification.errors.full_messages)
      end
    end
  end
end
