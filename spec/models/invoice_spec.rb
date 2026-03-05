require "rails_helper"

RSpec.describe Invoice, type: :model do
  it "is valid with factory defaults" do
    expect(build(:invoice)).to be_valid
  end
end
