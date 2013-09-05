class Bill
  require 'open-uri'
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :tags, type: Array
  field :bill_version, type: String
  field :effective_date, type: Time
  field :document_attachment, type: String

  include Sunspot::Mongoid2
  searchable do
    text :title
    text :tags
    text :bill_version
    time :effective_date
    attachment :document_attachment
  end

  def to_param
    id
  end
end
