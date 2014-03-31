class Cl::Document
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill, class_name: 'Cl::Bill'

  field :number, :type => String
  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
  field :type, :type => String
  field :chamber, :type => String
  field :link, :type => String
end