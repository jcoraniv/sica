require "rails_helper"

RSpec.describe Zone, type: :model do
  it "is valid with factory defaults" do
    expect(build(:zone)).to be_valid
  end
end
