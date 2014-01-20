class Priority
  include Mongoid::Document
  include Mongoid::Timestamps

  include Billit::PriorityRepresenter

  belongs_to :bill

  field :type, :type => String
  field :entry_date, :type => DateTime
  field :entry_message, :type => String
  field :entry_chamber, :type => String
  field :withdrawal_date, :type => DateTime
  field :withdrawal_message, :type => String
  field :withdrawal_chamber, :type => String
end