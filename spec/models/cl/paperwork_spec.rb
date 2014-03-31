require 'spec_helper'

describe Cl::Paperwork do
  it "saves a valid timeline_status" do
  	@paperwork1 = FactoryGirl.build(:cl_paperwork1)
  	@paperwork2 = FactoryGirl.build(:cl_paperwork2)
    @bill = FactoryGirl.create(:cl_bill1)
    @bill.paperworks = [@paperwork1, @paperwork2]
    @bill.save
    @paperwork1.save
    @paperwork2.save
  	@paperwork1.timeline_status.should eq 'Ingreso'
  	@paperwork2.timeline_status.should eq 'Tramitación Terminada'
  end
end
