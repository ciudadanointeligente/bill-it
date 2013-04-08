require 'faker'

FactoryGirl.define do
  factory :bill do |f|
    f.uid { Faker::PhoneNumber.phone_number }
    f.title { Faker::Lorem.sentences }
    f.summary { Faker::Lorem.sentences }
    f.tags { [Faker::Lorem.words, Faker::Lorem.words, Faker::Lorem.words] }
    f.matters { [Faker::Lorem.words, Faker::Lorem.words, Faker::Lorem.words] }
    f.stage { Faker::Lorem.words }
    f.creation_date '2010-12-01'
    f.publish_date '2010-12-01'
    f.authors { Faker::Name.name }
    f.origin_chamber { Faker::Lorem.word }
    f.current_urgency { Faker::Lorem.word }
    f.link_law { Faker::Internet.url }
  end
end