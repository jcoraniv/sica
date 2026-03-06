module Notifications
  class EventDispatcher
    BACKEND_MAP = {
      "inline" => "Notifications::Backends::InlineBackend",
      "active_job" => "Notifications::Backends::ActiveJobBackend",
      "web_push" => "Notifications::Backends::WebPushBackend",
      "null" => "Notifications::Backends::NullBackend"
    }.freeze

    def self.dispatch(event_name, payload = {})
      backend.deliver(event_name, payload)
    end

    def self.backend
      @backend ||= build_backend
    end

    def self.build_backend
      backend_key = Rails.configuration.x.notifications.backend.to_s
      class_name = BACKEND_MAP.fetch(backend_key, BACKEND_MAP["inline"])
      class_name.constantize.new
    end
    private_class_method :build_backend
  end
end
