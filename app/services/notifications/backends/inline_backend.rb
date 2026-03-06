module Notifications
  module Backends
    class InlineBackend
      def deliver(event_name, payload)
        case event_name
        when "reading.created"
          reading = Reading.find_by(id: payload[:reading_id])
          Notifications::NotifyReadingService.call(reading: reading) if reading.present?
        when "invoice.paid"
          invoice = Invoice.find_by(id: payload[:invoice_id])
          Notifications::NotifyPaymentService.call(invoice: invoice) if invoice.present?
        end
      end
    end
  end
end
