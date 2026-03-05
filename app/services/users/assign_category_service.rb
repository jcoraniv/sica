module Users
  class AssignCategoryService
    def self.call(user:, category:)
      if user.update(category: category)
        ServiceResult.success(payload: { user: user })
      else
        ServiceResult.failure(errors: user.errors.full_messages)
      end
    end
  end
end
