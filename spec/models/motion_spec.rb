require 'spec_helper'

describe Motion do
  it "has a valid factory" do
    FactoryGirl.create(:motion).should be_valid
  end

  # it "is invalid without an uique id (uid)" do
  #   FactoryGirl.build(:bill, uid: nil).should_not be_valid
  # end
end
