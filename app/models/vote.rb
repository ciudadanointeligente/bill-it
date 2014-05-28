class Vote
  include Mongoid::Document
  field :voter_id, type: String
  field :option, type: String
end
