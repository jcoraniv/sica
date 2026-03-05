class InvoicePolicy < ApplicationPolicy
  def create?
    user.admin? || user.lecturador?
  end

  def show?
    user.admin? || record.user_id == user.id || record.reading.lecturador_id == user.id
  end
end
