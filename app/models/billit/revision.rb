class Revision
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :bill

  field :description, :type => String
end