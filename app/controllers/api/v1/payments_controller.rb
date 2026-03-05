module Api
  module V1
    class PaymentsController < BaseController
      def create
        invoice = Invoice.find(params.require(:invoice_id))
        authorize Payment, :create?

        result = Payments::RegisterPaymentService.call(
          invoice: invoice,
          admin: current_user,
          amount_paid: params.require(:amount_paid),
          paid_at: params[:paid_at] || Time.current
        )

        render_result(result, success_status: :created)
      end
    end
  end
end
