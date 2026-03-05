module Api
  module V1
    class InvoicesController < BaseController
      def create
        reading = Reading.find(params.require(:reading_id))
        authorize Invoice, :create?

        result = Invoices::GenerateInvoiceService.call(reading: reading)
        render_result(result, success_status: :created)
      end

      def pdf
        invoice = Invoice.find(params[:id])
        authorize invoice, :show?

        result = Invoices::GeneratePdfService.call(invoice: invoice)
        return render_result(result) unless result.success?

        send_data result.payload[:data], filename: result.payload[:filename], type: "application/pdf", disposition: "inline"
      end
    end
  end
end
