class Bill
  require 'open-uri'
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :uid
  validates_uniqueness_of :uid

  before_save :standardize_tags, :set_law_link

  embeds_many :paperworks
  embeds_many :priorities
  embeds_many :reports
  embeds_many :revisions
  embeds_many :documents
  embeds_many :directives
  embeds_many :remarks
  
  field :uid, type: String
  field :title, type: String
  field :abstract, type: String
  field :creation_date, type: Time
  field :source, type: String
  field :inital_chamber, type: String
  field :current_priority, type: String
  field :stage, type: String
  field :sub_stage, type: String
  field :status, type: String
  field :resulting_document, type: String
  field :law_link, type: String
  field :merged_bills, type: String
  field :subject_areas, type: Array
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
    text :source
    text :inital_chamber
    text :current_priority
    text :stage
    text :sub_stage
    text :status
    text :subject_areas
    text :authors
    time :publish_date
    text :tags
    time :updated_at
    #attachment type has to be a uri (local or remote)
    #if it's a string it will not get indexed
    attachment :law_text
  end

  def get_law_link
    #if self.law is a valid uri
    if self.law =~ URI::regexp
      URI.encode self.law
    elsif !self.law.blank?
      law_number = self.law.gsub(/Ley[^\d]*(\d+)\.?(\d*)/, '\1\2')
      "http://www.leychile.cl/Consulta/obtxml?opt=7&idLey=" + law_number
    end
  end

  def law_text
    get_law_link
  end

  def set_law_link
    self.law_link = get_law_link
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
