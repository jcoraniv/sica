module Notifications
  class NotifyReadingService
    def self.call(reading:)
      notification = Notification.new(
        user: reading.meter.user,
        title: I18n.t("services.notifications.notify_reading.title"),
        body: I18n.t("services.notifications.notify_reading.body", consumption: reading.consumption_m3, amount: reading.amount_due),
        kind: :reading
      )

      if notification.save
        ServiceResult.success(payload: { notification: notification })
      else
        ServiceResult.failure(errors: notification.errors.full_messages)
      end
    end
  end
end
