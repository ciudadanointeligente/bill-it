class Document
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  field :number, :type => String
  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
  field :type, :type => String
  field :chamber, :type => String
end