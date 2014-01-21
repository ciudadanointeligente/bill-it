class Billit::Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
end