module Notifications
  class WebPushDeliveryService
    class << self
      def call(user:, title:, body:, path: "/admin")
        subscription = user.push_subscription
        return ServiceResult.failure(errors: [I18n.t("services.notifications.web_push.missing_subscription")]) if subscription.blank?
        return ServiceResult.failure(errors: [I18n.t("services.notifications.web_push.invalid_subscription")]) unless valid_subscription?(subscription)
        return ServiceResult.failure(errors: [I18n.t("services.notifications.web_push.missing_vapid")]) unless vapid_configured?

        payload = {
          title: title,
          options: {
            body: body,
            data: { path: path }
          }
        }

        Webpush.payload_send(
          message: payload.to_json,
          endpoint: subscription["endpoint"],
          p256dh: subscription.dig("keys", "p256dh"),
          auth: subscription.dig("keys", "auth"),
          vapid: vapid_options
        )

        ServiceResult.success
      rescue Webpush::InvalidSubscription
        user.update_column(:push_subscription, {})
        ServiceResult.failure(errors: [I18n.t("services.notifications.web_push.invalid_subscription")])
      rescue StandardError => e
        Rails.logger.error("[WebPushDeliveryService] #{e.class}: #{e.message}")
        ServiceResult.failure(errors: [I18n.t("services.notifications.web_push.delivery_failed")])
      end

      private

      def valid_subscription?(subscription)
        subscription["endpoint"].present? &&
          subscription.dig("keys", "p256dh").present? &&
          subscription.dig("keys", "auth").present?
      end

      def vapid_options
        {
          subject: ENV["WEB_PUSH_VAPID_SUBJECT"],
          public_key: ENV["WEB_PUSH_VAPID_PUBLIC_KEY"],
          private_key: ENV["WEB_PUSH_VAPID_PRIVATE_KEY"]
        }
      end

      def vapid_configured?
        vapid_options.values.all?(&:present?)
      end
    end
  end
end
