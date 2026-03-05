module Admin
  class InvoicesController < BaseController
    def index
      scope = if current_user.admin?
                Invoice.includes(:user)
              elsif current_user.lecturador?
                Invoice.joins(:reading).where(readings: { lecturador_id: current_user.id }).includes(:user)
              else
                Invoice.where(user: current_user)
              end
      @q = scope.ransack(params[:q])
      @pagy, @invoices = pagy(@q.result(distinct: true).order(issued_at: :desc))
    end

    def create
      reading = Reading.find(params.require(:reading_id))
      result = Invoices::GenerateInvoiceService.call(reading: reading)

      if result.success?
        redirect_to admin_invoices_path, notice: t("controllers.admin.invoices.generated")
      else
        redirect_to admin_readings_path, alert: result.errors.join(", ")
      end
    end

    def pdf
      invoice = Invoice.find(params[:id])
      unless can_view_invoice?(invoice)
        redirect_to admin_invoices_path, alert: t("controllers.admin.shared.unauthorized")
        return
      end

      result = Invoices::GeneratePdfService.call(invoice: invoice)
      if result.success?
        send_data result.payload[:data], filename: result.payload[:filename], type: "application/pdf", disposition: "inline"
      else
        redirect_to admin_invoices_path, alert: result.errors.join(", ")
      end
    end

    def edit
      require_admin!
      @invoice = Invoice.find(params[:id])
      if @invoice.paid?
        redirect_to admin_invoices_path, alert: t("controllers.admin.invoices.paid_immutable")
      end
    end

    def update
      require_admin!
      @invoice = Invoice.find(params[:id])
      if @invoice.paid?
        redirect_to admin_invoices_path, alert: t("controllers.admin.invoices.paid_immutable")
        return
      end

      if @invoice.update(invoice_params)
        redirect_to admin_invoices_path, notice: t("controllers.admin.invoices.updated")
      else
        flash.now[:alert] = @invoice.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def invoice_params
      params.require(:invoice).permit(:due_at, :notes)
    end

    def can_view_invoice?(invoice)
      return true if current_user.admin?
      return true if current_user.lecturador? && invoice.reading.lecturador_id == current_user.id

      invoice.user_id == current_user.id
    end
  end
end
