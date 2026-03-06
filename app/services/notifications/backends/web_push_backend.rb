module Notifications
  module Backends
    class WebPushBackend
      # Placeholder backend to allow switching strategy without changing callers.
      # For now it reuses InlineBackend and can be replaced with real web-push delivery.
      def deliver(event_name, payload)
        InlineBackend.new.deliver(event_name, payload)
      end
    end
  end
end
