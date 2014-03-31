FactoryGirl.define do
  factory :cl_report, class: Cl::Report do

  	factory :cl_report1 do |r|
      r.date "2014-01-01 11:35:01"
      r.step "Ingreso de proyecto ."
      r.stage "Primer trámite constitucional"
      r.link "http://report-example-site.org"
    end
  end
end