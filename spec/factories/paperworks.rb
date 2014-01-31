# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paperwork, :class => 'Paperwork' do

  	factory :paperwork1 do |b|
      b.session "/"
      b.date "2014-01-01 11:35:01"
      b.description "Ingreso de proyecto ."
      b.stage "Primer trámite constitucional"
      b.chamber "C.Diputados"
    end
    factory :paperwork2 do |b|
      b.session "20/343"
      b.date "2013-01-01 11:35:01"
      b.description "Oficio de ley al Ejecutivo ."
      b.stage "Trámite finalización en Cámara de Origen"
      b.chamber "Senado"
    end
  end
end
