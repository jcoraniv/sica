module Notifications
  module Backends
    class WebPushBackend
      def deliver(event_name, payload)
        case event_name
        when "reading.created"
          reading = Reading.find_by(id: payload[:reading_id])
          return if reading.blank?

          result = Notifications::NotifyReadingService.call(reading: reading)
          return unless result.success?

          notification = result.payload[:notification]
          Notifications::WebPushDeliveryService.call(
            user: notification.user,
            title: notification.title,
            body: notification.body,
            path: "/admin/readings"
          )
        when "invoice.paid"
          invoice = Invoice.find_by(id: payload[:invoice_id])
          return if invoice.blank?

          result = Notifications::NotifyPaymentService.call(invoice: invoice)
          return unless result.success?

          notification = result.payload[:notification]
          Notifications::WebPushDeliveryService.call(
            user: notification.user,
            title: notification.title,
            body: notification.body,
            path: "/admin/invoices"
          )
        end
      end
    end
  end
end
