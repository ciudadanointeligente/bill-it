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

  it "creates the law_xml_link field when saved" do
    bill1 = FactoryGirl.create(:bill, uid: 1, resulting_document: "Ley Nº 20.000")
    bill2 = FactoryGirl.create(:bill, uid: 2, resulting_document: "D.S. Nº 1.358")
    bill1.save
    bill2.save
    bill1.law_xml_link.should eq("http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=20000")
    bill2.law_xml_link.should be_nil
  end

  it "creates the law_web_link field when saved" do
    bill1 = FactoryGirl.create(:bill, uid: 1, resulting_document: "Ley Nº 20.000")
    bill2 = FactoryGirl.create(:bill, uid: 2, resulting_document: "D.S. Nº 1.358")
    bill1.save
    bill2.save
    bill1.law_web_link.should eq("http://www.leychile.cl/Navegar?idLey=20000")
    bill2.law_web_link.should be_nil
  end

  describe "current_priority" do
    it "returns the right priority" do
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today)
      priority2 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.yesterday)
      bill1.priorities = [priority1, priority2]
      bill1.save
      bill1.current_priority.should eq "Discusión inmediata"
    end
    it "returns the right value when no priority is set" do
      bill1 = FactoryGirl.create(:bill1)
      bill1.current_priority.should eq "Sin urgencia"
    end
    it "returns the right value when priority is outdated" do
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: 2.business_days.ago)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Discusión inmediata"
      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: 3.business_days.ago)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
    it "doesn't count weekends as working days" do
      Date.stub(:today){"2014-01-13".to_date}
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.today - 7)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Suma"

      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.today - 10)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
    it "doesn't count holidays as working days" do
      Date.stub(:today){"2014-01-06".to_date}
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.today - 10)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Suma"

      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.today - 11)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
  end

end