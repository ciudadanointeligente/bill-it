# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote_event do
    startDate "2014-05-28 17:07:28"
    endDate "2014-05-28 17:07:28"
    count { FactoryGirl.build(:count) }
    votes { [FactoryGirl.build(:vote)] }
  end
end
