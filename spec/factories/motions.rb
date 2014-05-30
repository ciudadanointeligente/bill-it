# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :motion do
    organization "MyString"
    context "MyString"
    creator "MyString"
    text "MyString"
    date "2014-05-28 17:03:01"
    requirement "MyString"
    result "MyString"
    session "MyString"
    vote_events { [FactoryGirl.build(:vote_event)] }
  end
end
