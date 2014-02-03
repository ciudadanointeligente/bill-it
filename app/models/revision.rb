class Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  field :description, :type => String
  field :link, :type => String
end