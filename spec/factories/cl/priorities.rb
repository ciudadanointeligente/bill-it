FactoryGirl.define do
  factory :cl_priority, class: Cl::Priority do

  	factory :cl_priority1 do |p|
      p.type "Ingreso de proyecto ."
      p.entry_date "2014-01-01 11:35:01"
    end

    factory :cl_priority2 do |p|
      p.type "Ingreso de proyecto ."
      p.entry_date "2014-01-01 11:35:01"
    end
  end
end