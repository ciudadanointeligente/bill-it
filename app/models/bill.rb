class Bill
  require 'open-uri'
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :uid
  validates_uniqueness_of :uid

  before_save :standardize_tags
  
  field :uid, type: String
  field :title, type: String
  field :abstract, type: String
  field :status, type: String
  field :authors, type: Array
  field :bill_draft_link, type: String
  field :resulting_document, type: String
  field :creation_date, type: Time
  field :publish_date, type: Time
  field :tags, type: Array

  include Sunspot::Mongoid2
  searchable do
    text :uid
    text :title
    text :abstract
    text :status
    text :authors
    time :creation_date
    time :publish_date
    text :tags
    time :updated_at
    #attachment type has to be a uri (local or remote)
    #if it's a string it will not get indexed
    attachment :bill_draft
  end

  def to_param
    uid
  end

  def standardize_tags
    self.tags.map! do |tag|
      tag = I18n.transliterate(tag, locale: :transliterate_special).downcase
    end if self.tags
  end

  # The method below only exist so the query field has a nicer name
  def bill_draft
    self.bill_draft_link
  end
end