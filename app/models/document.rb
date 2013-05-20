class Document
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :bill

  field :date, :type => DateTime
  field :number, :type => String
  field :event, :type => String
  field :stage, :type => String
  field :type, :type => String
  field :chamber, :type => String
end