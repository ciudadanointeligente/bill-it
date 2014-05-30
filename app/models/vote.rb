class Vote
  include Mongoid::Document

  embedded_in :vote_event

  field :voter_id, type: String
  field :option, type: String
end
