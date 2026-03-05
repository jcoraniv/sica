require "rails_helper"

RSpec.describe Category, type: :model do
  it "is valid with factory defaults" do
    expect(build(:category)).to be_valid
  end
end
