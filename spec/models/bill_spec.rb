require 'spec_helper'

describe Bill do

  it "has a valid factory" do
    FactoryGirl.create(:bill).should be_valid
  end

  it "is invalid without an uique id (uid)" do
    FactoryGirl.build(:bill, uid: nil).should_not be_valid
  end

  it "is invalid with an existing id (uid)" do
    FactoryGirl.create(:bill, uid: 123456)
    FactoryGirl.build(:bill, uid: 123456).should_not be_valid
  end

end