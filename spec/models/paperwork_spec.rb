require 'spec_helper'

describe Paperwork do
  it "saves a valid timeline_status" do
  	@paperwork1 = FactoryGirl.build(:paperwork1)
  	@paperwork2 = FactoryGirl.build(:paperwork2)
    @bill = FactoryGirl.create(:bill1)
    @bill.paperworks = [@paperwork1, @paperwork2]
    @bill.save
    @paperwork1.save
    @paperwork2.save
  	@paperwork1.timeline_status.should eq 'Ingreso'
  	@paperwork2.timeline_status.should eq 'Tramitación Terminada'
  end
end
