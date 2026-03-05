require "rails_helper"

RSpec.describe Reading, type: :model do
  it "is valid with factory defaults" do
    expect(build(:reading)).to be_valid
  end
end
