class InvoicePdf
  def self.render(invoice)
    Invoices::GeneratePdfService.call(invoice: invoice)
  end
end
