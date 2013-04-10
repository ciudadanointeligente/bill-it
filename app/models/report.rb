class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :bill

  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
end