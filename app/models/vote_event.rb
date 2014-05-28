class VoteEvent
  include Mongoid::Document
  field :startDate, type: Time
  field :endDate, type: Time
end
