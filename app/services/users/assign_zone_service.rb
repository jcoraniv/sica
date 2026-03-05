module Users
  class AssignZoneService
    def self.call(user:, zone:)
      if user.update(zone: zone)
        ServiceResult.success(payload: { user: user })
      else
        ServiceResult.failure(errors: user.errors.full_messages)
      end
    end
  end
end
