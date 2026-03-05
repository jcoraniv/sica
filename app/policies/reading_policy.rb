class ReadingPolicy < ApplicationPolicy
  def create?
    user.admin? || user.lecturador?
  end

  def update?
    user.admin? || (user.lecturador? && record.lecturador_id == user.id)
  end
end
