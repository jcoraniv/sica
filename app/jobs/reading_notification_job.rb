class ReadingNotificationJob < ApplicationJob
  queue_as :default

  def perform(reading_id)
    reading = Reading.find_by(id: reading_id)
    return if reading.blank?

    Notifications::NotifyReadingService.call(reading: reading)
  end
end
