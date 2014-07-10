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

  it "gets indexed after save" do
    search = Sunspot.search Bill do
      fulltext "pena"
    end
    search.results.count.should eq 0
    bill1 = FactoryGirl.create(:bill1)
    search = Sunspot.search Bill do
      fulltext "pena"
    end
    search.results.count.should eq 1
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
    it "returns no priority value with future dates" do
      bill1 = FactoryGirl.create(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.tomorrow)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Sin urgencia"
    end
    it "works with more than 1 priority" do
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Simple", entry_date: Date.yesterday)
      priority2 = FactoryGirl.create(:priority1, type: "Suma", entry_date: Date.today)
      bill1.priorities = [priority1, priority2]
      bill1.save
      bill1.current_priority.should eq "Suma"
    end
    it "returns the right value when priority is outdated" do
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: 6.days.ago)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Discusión inmediata"
      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: 7.days.ago)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
    it "counts weekends" do
      Date.stub(:today){"2014-01-13".to_date}
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 6)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Discusión inmediata"

      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 7)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
    it "counts holidays" do
      Date.stub(:today){"2014-01-06".to_date}
      bill1 = FactoryGirl.build(:bill1)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 6)
      bill1.priorities = [priority1]
      bill1.save
      bill1.current_priority.should eq "Discusión inmediata"

      bill2 = FactoryGirl.build(:bill2)
      priority2 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 7)
      bill2.priorities = [priority2]
      bill2.save
      bill2.current_priority.should eq "Sin urgencia"
    end
  end

  describe "self.update_priority" do
    before(:each) do
      Date.stub(:today){"2014-01-06".to_date}
      @bill1 = FactoryGirl.build(:bill1)
      @bill2 = FactoryGirl.build(:bill2)
      priority1 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 6)
      priority2 = FactoryGirl.create(:priority1, type: "Discusión inmediata", entry_date: Date.today - 7)
      @bill1.priorities = [priority1]
      @bill2.priorities = [priority2]
      @bill1.save
      @bill2.save
    end
    it "updates outdated bill priorities for all bills" do
      # Day 1
      @bill1.current_priority.should eq "Discusión inmediata"
      @bill2.current_priority.should eq "Sin urgencia"
      # The next day
      Date.stub(:today){"2014-01-07".to_date}
      Bill.update_priority
      updated_bill1 = Bill.find_by uid: @bill1.uid
      updated_bill2 = Bill.find_by uid: @bill2.uid
      updated_bill1.current_priority.should eq "Sin urgencia"
      updated_bill2.current_priority.should eq "Sin urgencia"
    end

    it "indexes the updated bill priorities" do
      Bill.update_priority

      Sunspot.remove_all(Bill)
      Sunspot.index!(@bill1)
      Sunspot.index!(@bill2)
      search = Sunspot.search Bill do
        text_fields do
          with :current_priority, "Sin urgencia"
        end
      end
      search.results.count.should eq 1
    end
  end
end