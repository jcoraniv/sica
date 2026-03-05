module Admin
  class PaymentsController < BaseController
    before_action :require_admin!

    def index
      @q = Payment.includes(:invoice, :admin).ransack(params[:q])
      @pagy, @payments = pagy(@q.result(distinct: true).order(paid_at: :desc))
      @payment_form = params[:edit_id].present? ? Payment.find(params[:edit_id]) : Payment.new(paid_at: Time.current)
      if @payment_form.persisted?
        invoice_ids = Invoice.pending.pluck(:id) << @payment_form.invoice_id
        @invoice_options = Invoice.includes(:user).where(id: invoice_ids.uniq).order(:due_at)
      else
        @invoice_options = Invoice.pending.includes(:user).order(:due_at)
      end
    end

    def create
      payment_attrs = params[:payment] || {}
      invoice_id = params[:invoice_id] || payment_attrs[:invoice_id]
      amount_paid = params[:amount_paid] || payment_attrs[:amount_paid]
      paid_at = params[:paid_at] || payment_attrs[:paid_at]

      invoice = Invoice.find(invoice_id)
      result = Payments::RegisterPaymentService.call(
        invoice: invoice,
        admin: current_user,
        amount_paid: amount_paid,
        paid_at: paid_at.presence || Time.current
      )

      if result.success?
        redirect_to admin_payments_path, notice: t("controllers.admin.payments.created")
      else
        redirect_to admin_payments_path, alert: result.errors.join(", ")
      end
    end

    def update
      payment = Payment.find(params[:id])
      attrs = payment_update_params.merge(admin: current_user)

      if payment.update(attrs)
        redirect_to admin_payments_path, notice: t("controllers.admin.payments.updated")
      else
        redirect_to admin_payments_path(edit_id: payment.id), alert: payment.errors.full_messages.join(", ")
      end
    end

    private

    def payment_update_params
      params.require(:payment).permit(:amount_paid, :paid_at)
    end
  end
end
