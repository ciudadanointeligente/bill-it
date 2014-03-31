class Cl::Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill, class_name: 'Cl::Bill'

  field :description, :type => String
  field :link, :type => String
end