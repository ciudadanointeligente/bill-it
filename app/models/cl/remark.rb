class Cl::Remark
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill, class_name: 'Cl::Bill'

  field :date, :type => DateTime
  field :event, :type => String
  field :stage, :type => String
end