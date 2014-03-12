FactoryGirl.define do
  factory :priority, :class => 'Priority' do

  	factory :priority1 do |p|
      p.type "Ingreso de proyecto ."
      p.entry_date "2014-01-01 11:35:01"
    end

    factory :priority2 do |p|
      p.type "Ingreso de proyecto ."
      p.entry_date "2014-01-01 11:35:01"
    end
  end
end