class ServiceResult
  attr_reader :payload, :errors

  def initialize(success:, payload: {}, errors: [])
    @success = success
    @payload = payload
    @errors = Array(errors)
  end

  def success?
    @success
  end

  def self.success(payload: {})
    new(success: true, payload: payload)
  end

  def self.failure(errors:, payload: {})
    new(success: false, errors: errors, payload: payload)
  end
end
