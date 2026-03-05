module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    layout "admin"

    private

    def require_admin!
      return if current_user.admin?

      redirect_to admin_root_path, alert: t("controllers.admin.shared.unauthorized")
    end

    def require_reader_or_admin!
      return if current_user.admin? || current_user.lecturador?

      redirect_to admin_root_path, alert: t("controllers.admin.shared.unauthorized")
    end

    def current_user_scope_for(collection, user_assoc: :user)
      return collection if current_user.admin?

      collection.where(user_assoc => current_user)
    end
  end
end
