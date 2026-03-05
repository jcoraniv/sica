ActiveSupport::Notifications.subscribe("reading.created") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  ReadingNotificationJob.perform_later(event.payload[:reading_id])
end

ActiveSupport::Notifications.subscribe("invoice.paid") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  PaymentNotificationJob.perform_later(event.payload[:invoice_id])
end
