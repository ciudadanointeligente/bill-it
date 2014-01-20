class Paperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  include Billit::PaperworkRepresenter

  # embedded_in :bill
  belongs_to :bill

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String
end