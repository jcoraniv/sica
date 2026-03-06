module Notifications
  module Backends
    class NullBackend
      def deliver(_event_name, _payload)
        true
      end
    end
  end
end
