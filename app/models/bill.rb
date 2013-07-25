class Bill
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :uid
  validates_uniqueness_of :uid

  before_save :standardize_tags

  embeds_many :events
  embeds_many :urgencies
  embeds_many :reports
  embeds_many :modifications
  embeds_many :documents
  embeds_many :instructions
  embeds_many :observations

  has_many :attachments
  
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

  include Sunspot::Mongoid2
  searchable do
    text :uid
    text :short_uid
    text :title
    text :summary
    text :stage
    time :creation_date
    time :publish_date
    time :updated_at
    text :origin_chamber
    text :current_urgency
  end

  def to_param
    uid
  end

  def standardize_tags
    self.tags.map! do |tag|
      tag = I18n.transliterate(tag, locale: :transliterate_special).downcase
    end if self.tags
  end

  def short_uid
    self.uid.split("-")[0]
  end
end
