class Paperwork
# class Papperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  before_save :save_bill_uid, :index_paperwork

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String
  field :bill_uid, :type => String

  include Sunspot::Mongoid2
  searchable do
    text :session
    time :date
    text :description
    text :stage
    text :chamber
  end

  def save_bill_uid
    bill = Bill.find(self.bill_id)
    self.bill_uid = bill.uid
  end

  def index_paperwork
    Sunspot.index!(self)
  end
end