module Invoices
  class GeneratePdfService
    def self.call(invoice:)
      pdf = Prawn::Document.new
      pdf.text I18n.t("services.invoices.generate_pdf.title"), size: 20, style: :bold
      pdf.move_down 10
      pdf.text I18n.t("services.invoices.generate_pdf.invoice_number", id: invoice.id)
      pdf.text I18n.t("services.invoices.generate_pdf.user", user: invoice.user.name)
      pdf.text I18n.t("services.invoices.generate_pdf.meter", meter: invoice.reading.meter.serial_number)
      pdf.text I18n.t("services.invoices.generate_pdf.consumption", consumption: invoice.reading.consumption_m3)
      pdf.text I18n.t("services.invoices.generate_pdf.total_amount", amount: invoice.total_amount)
      pdf.text I18n.t("services.invoices.generate_pdf.issued_at", date: invoice.issued_at.strftime("%Y-%m-%d"))
      pdf.text I18n.t("services.invoices.generate_pdf.due_at", date: invoice.due_at.strftime("%Y-%m-%d"))

      ServiceResult.success(payload: { data: pdf.render, filename: I18n.t("services.invoices.generate_pdf.filename", id: invoice.id) })
    rescue StandardError => e
      ServiceResult.failure(errors: [e.message])
    end
  end
end
