class Directive
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :bill

  field :date, :type => DateTime
  field :event, :type => String
  field :stage, :type => String
end