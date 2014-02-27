FactoryGirl.define do
  factory :document, :class => 'Document' do

  	factory :document1 do |b|
      b.date "2014-01-01 11:35:01"
      b.step "Ingreso de proyecto ."
      b.stage "Primer trámite constitucional"
      b.link "http://document-example-site.org"
    end

    factory :inconsistent_data_document do |b|
      b.date "2014-01-01 11:35:01"
      b.step "Ingreso de proyecto ."
      b.stage "Primer tramite cónstitucional . "
      b.link "http://docuent-example-site.org"
    end
  end
end