class Bill
  include Mongoid::Document

  validates_presence_of :uid
  validates_uniqueness_of :uid

  embeds_many :events
  embeds_many :urgencies
  embeds_many :reports
  
  field :uid, type: String
  field :title, type: String
  field :summary, type: String
  field :tags, type: Array
  field :matters, type: Array
  field :stage, type: String
  field :creation_date, type: Time
  field :publish_date, type: Time
  field :authors, type: Array
  field :origin_chamber, type: String
  field :current_urgency, type: String
  field :link_law, type: String
end
