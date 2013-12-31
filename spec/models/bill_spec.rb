# encoding: UTF-8
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

  it "saves tags in lowercase" do
    bill = FactoryGirl.create(:bill, uid: 123456)
    bill.tags = ['áéíóúüñ', 'ÑÜÚÓÍÉÁ']
    bill.save
    bill = Bill.find_by(uid: 123456)
    bill.tags.should eq(['aeiouuñ', 'ñuuoiea'])
  end

  it "creates the link_law field when saved" do
    bill1 = FactoryGirl.create(:bill, uid: 1, resulting_document: "Ley Nº 20.000")
    bill2 = FactoryGirl.create(:bill, uid: 2, resulting_document: "http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=19029")
    bill1.save
    bill2.save
    bill1.law_link.should eq("http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=20000")
    bill2.law_link.should eq("http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=19029")
  end

end