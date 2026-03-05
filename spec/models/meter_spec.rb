require "rails_helper"

RSpec.describe Meter, type: :model do
  it "is valid with factory defaults" do
    expect(build(:meter)).to be_valid
  end
end
