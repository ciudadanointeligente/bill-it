# encoding: UTF-8
FactoryGirl.define do
  factory :bill do

    uid '0-0'

    factory :bill1 do |f|
      f.uid "1-07"
      f.title "Modifica los Códigos de Justicia Militar, Penal y Aeronáutico para abolir la Pena de Muerte."
      f.summary "Abolición de la pena de muerte."
      f.tags ["Pena de muerte", "Justicia"]
      f.matters ["Derechos Fundamentales"]
      f.stage "Tramitación terminada"
      f.creation_date "1990-03-20T00:00:00Z"
      f.publish_date "1991-01-23T00:00:00Z"
      f.authors []
      f.origin_chamber "C.Diputados"
      f.current_urgency nil
      f.link_law "http://bcn.cl/19im1"
    end
    factory :bill2 do |f|
      f.uid "3773-06"
      f.title "Sobre acceso a la información pública"
      f.summary "Ley de transparencia"
      f.tags ["Transparencia", "Acceso a la información pública"]
      f.matters ["Transparencia", "Participación"]
      f.stage "Tramitación terminada"
      f.creation_date "2005-01-04T00:00:00Z"
      f.publish_date "2008-08-11T00:00:00Z"
      f.authors ["Gazmuri Mujica, Jaime", "Larraín Fernández, Hernán"]
      f.origin_chamber "Senado"
      f.current_urgency nil
      f.link_law "http://bcn.cl/19ce2"
    end
    factory :bill3 do |f|
      f.uid "0000-00"
      f.title "Fake bill with terms información pública"
      f.summary "Ley de transparencia"
      f.tags ["Transparencia", "Acceso a la información pública"]
      f.matters ["Transparencia", "Participación"]
      f.stage "Tramitación terminada"
      f.creation_date "2007-01-04T00:00:00Z"
      f.publish_date "2009-08-11T00:00:00Z"
      f.authors ["Gazmuri Mujica, Jaime", "Larraín Fernández, Hernán"]
      f.origin_chamber "C.Diputados"
      f.current_urgency nil
      f.link_law "http://bcn.cl/19ce2"
    end
  end
end