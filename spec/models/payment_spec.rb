require "rails_helper"

RSpec.describe Payment, type: :model do
  it "is valid with factory defaults" do
    expect(build(:payment)).to be_valid
  end
end
