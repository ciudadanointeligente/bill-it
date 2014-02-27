FactoryGirl.define do
  factory :report, :class => 'Report' do

  	factory :report1 do |r|
      r.date "2014-01-01 11:35:01"
      r.step "Ingreso de proyecto ."
      r.stage "Primer trámite constitucional"
      r.link "http://report-example-site.org"
    end
  end
end