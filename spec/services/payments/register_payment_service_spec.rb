require "rails_helper"

RSpec.describe Payments::RegisterPaymentService do
  describe ".call" do
    it "marca la factura como pagada y crea el pago" do
      invoice = create(:invoice, status: :pending)
      admin = create(:user, :admin)

      result = described_class.call(invoice: invoice, admin: admin, amount_paid: invoice.total_amount)

      expect(result).to be_success
      expect(result.payload[:payment]).to be_persisted
      expect(result.payload[:invoice]).to be_paid
    end

    it "rechaza cobro por usuario no admin" do
      invoice = create(:invoice, status: :pending)
      user = create(:user, role: :usuario)

      result = described_class.call(invoice: invoice, admin: user, amount_paid: invoice.total_amount)

      expect(result).not_to be_success
      expect(result.errors).to include("Only admin can register payments")
    end
  end
end
