class Bill
  require 'open-uri'
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :uid
  validates_uniqueness_of :uid

  before_save :standardize_tags, :set_link_law

  embeds_many :events
  embeds_many :urgencies
  embeds_many :reports
  embeds_many :modifications
  embeds_many :documents
  embeds_many :instructions
  embeds_many :observations
  
  field :uid, type: String
  field :title, type: String
  field :abstract, type: String
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
  field :tags, type: Array

  include Sunspot::Mongoid2
  searchable do
    text :uid
    text :short_uid
    text :title
    text :abstract
    time :creation_date
    text :initiative
    text :origin_chamber
    text :current_urgency
    text :stage
    text :sub_stage
    text :state
    text :matters
    text :authors
    time :publish_date
    text :tags
    time :updated_at
    #attachment type has to be a uri (local or remote)
    #if it's a string it will not get indexed
    attachment :law_text
  end

  def get_link_law
    #if self.law is a valid uri
    if self.law =~ URI::regexp
      URI.encode self.law
    elsif !self.law.blank?
      law_number = self.law.gsub(/Ley[^\d]*(\d+)\.?(\d*)/, '\1\2')
      "http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=" + law_number
    end
  end

  def law_text
    get_link_law
  end

  def set_link_law
    self.link_law = get_link_law
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
