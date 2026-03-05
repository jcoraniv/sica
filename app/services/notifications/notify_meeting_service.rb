module Notifications
  class NotifyMeetingService
    def self.call(users:, title:, body:)
      count = 0
      Notification.transaction do
        enum = users.respond_to?(:find_each) ? users.find_each : Array(users)
        enum.each do |user|
          Notification.create!(user: user, title: title, body: body, kind: :meeting)
          count += 1
        end
      end
      ServiceResult.success(payload: { count: count })
    rescue StandardError => e
      ServiceResult.failure(errors: [e.message])
    end
  end
end
