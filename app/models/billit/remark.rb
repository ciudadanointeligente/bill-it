class Billit::Remark
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  field :date, :type => DateTime
  field :event, :type => String
  field :stage, :type => String
end