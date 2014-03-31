class Cl::Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill, class_name: 'Cl::Bill'

  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
  field :link, :type => String
end