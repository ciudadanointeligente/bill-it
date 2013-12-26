class Paperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :bill

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String
end