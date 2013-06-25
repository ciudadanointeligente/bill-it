class Bill
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :uid
  validates_uniqueness_of :uid

  embeds_many :events
  embeds_many :urgencies
  embeds_many :reports
  embeds_many :modifications
  embeds_many :documents
  embeds_many :instructions
  embeds_many :observations
  
  field :uid, type: String
  field :title, type: String
  field :creation_date, type: Time
  field :initiative, type: String
  field :origin_chamber, type: String
  field :current_urgency, type: String
  field :stage, type: String
  field :sub_stage, type: String
  field :state, type: String
  field :law, type: String
  field :link_law, type: String
  field :merged, type: String
  field :matters, type: Array
  field :authors, type: Array
  field :publish_date, type: Time
  field :summary, type: String
  field :tags, type: Array

  include Sunspot::Mongoid
  searchable do
    text :uid
    text :title
    text :summary
    text :stage
    time :creation_date
    time :publish_date
    text :origin_chamber
    text :current_urgency
  end

  def to_param
    uid
  end
end
