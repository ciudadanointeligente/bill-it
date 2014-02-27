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
  	@paperwork2.timeline_status.should eq 'Estado por Defecto'
  end

  it "saves a valid document link" do
  	@paperwork1 = FactoryGirl.build(:paperwork1)
  	@paperwork2 = FactoryGirl.build(:paperwork2)
  	@document1 = FactoryGirl.create(:document1)
    @bill = FactoryGirl.create(:bill1)
    @bill.paperworks = [@paperwork1, @paperwork2]
    @bill.documents = [@document1]
    @bill.save
    @paperwork1.save
    @paperwork2.save
  	@paperwork1.document_link.should eq @document1.link
  	@paperwork2.document_link.should be_nil
  end

  context "with inconsistent data" do
	it "saves a valid document link " do
	  @paperwork1 = FactoryGirl.build(:paperwork1)
	  @inconsistent_data_document = FactoryGirl.create(:inconsistent_data_document)
	  @bill = FactoryGirl.create(:bill1)
	  @bill.paperworks = [@paperwork1]
	  @bill.documents = [@inconsistent_data_document]
	  @bill.save
	  @paperwork1.save
	  @paperwork1.document_link.should eq @inconsistent_data_document.link
	end
  end
end
