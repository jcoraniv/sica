module Admin
  class PushSubscriptionsController < BaseController
    def create
      subscription = params.require(:subscription).permit(:endpoint, :expirationTime, keys: [ :p256dh, :auth ]).to_h
      current_user.update_column(:push_subscription, subscription)
      head :no_content
    rescue ActionController::ParameterMissing
      render json: { success: false, errors: [I18n.t("controllers.admin.push_subscriptions.missing_params")] }, status: :unprocessable_entity
    end

    def destroy
      current_user.update_column(:push_subscription, {})
      head :no_content
    end
  end
end
