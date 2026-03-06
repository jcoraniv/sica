module Notifications
  module Backends
    class ActiveJobBackend
      def deliver(event_name, payload)
        case event_name
        when "reading.created"
          ReadingNotificationJob.perform_later(payload[:reading_id])
        when "invoice.paid"
          PaymentNotificationJob.perform_later(payload[:invoice_id])
        end
      end
    end
  end
end
