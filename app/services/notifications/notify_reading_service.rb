module Notifications
  class NotifyReadingService
    def self.call(reading:)
      notification = Notification.new(
        user: reading.meter.user,
        title: "Nueva lectura registrada",
        body: "Se registraron #{reading.consumption_m3} m3. Monto: #{reading.amount_due}",
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
