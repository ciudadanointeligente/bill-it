class Motion
  include Mongoid::Document
  field :organization, type: String
  field :context, type: String
  field :creator, type: String
  field :text, type: String
  field :date, type: Time
  field :requirement, type: String
  field :result, type: String
  field :session, type: String
end
