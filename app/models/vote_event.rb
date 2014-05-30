class VoteEvent
  include Mongoid::Document

  belongs_to :motion
  embeds_one :count#, autosave: true, class_name: "Count"
  embeds_many :votes

  field :startDate, type: Time
  field :endDate, type: Time
end
