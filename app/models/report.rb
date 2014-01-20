class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  include Billit::ReportRepresenter

  belongs_to :bill

  field :date, :type => DateTime
  field :step, :type => String
  field :stage, :type => String
end