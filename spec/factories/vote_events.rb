# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote_event do
    start_date "2014-05-28 17:07:28"
    end_date "2014-05-28 17:07:28"
    counts { [FactoryGirl.build(:count)] }
    votes { [FactoryGirl.build(:vote)] }
  end
end
