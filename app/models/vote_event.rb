class VoteEvent
  include Mongoid::Document

  belongs_to :motion
  embeds_many :counts#, autosave: true, class_name: "Count"
  embeds_many :votes

  field :start_date, type: Time
  field :end_date, type: Time
end
