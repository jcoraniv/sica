module Invoices
  class GeneratePdfService
    def self.call(invoice:)
      pdf = Prawn::Document.new
      pdf.text "Boleta de Agua Potable", size: 20, style: :bold
      pdf.move_down 10
      pdf.text "Factura ##{invoice.id}"
      pdf.text "Usuario: #{invoice.user.name}"
      pdf.text "Medidor: #{invoice.reading.meter.serial_number}"
      pdf.text "Consumo (m3): #{invoice.reading.consumption_m3}"
      pdf.text "Monto total: #{invoice.total_amount}"
      pdf.text "Emitida: #{invoice.issued_at.strftime('%Y-%m-%d')}"
      pdf.text "Vence: #{invoice.due_at.strftime('%Y-%m-%d')}"

      ServiceResult.success(payload: { data: pdf.render, filename: "invoice_#{invoice.id}.pdf" })
    rescue StandardError => e
      ServiceResult.failure(errors: [e.message])
    end
  end
end
