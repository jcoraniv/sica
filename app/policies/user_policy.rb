class UserPolicy < ApplicationPolicy
  def manage_assignments?
    user.admin?
  end
end
