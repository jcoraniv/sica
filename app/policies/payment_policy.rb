class PaymentPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
