ActiveSupport::Notifications.subscribe("reading.created") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  Notifications::EventDispatcher.dispatch(event.name, event.payload)
end

ActiveSupport::Notifications.subscribe("invoice.paid") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  Notifications::EventDispatcher.dispatch(event.name, event.payload)
end
