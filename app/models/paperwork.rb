class Paperwork
# class Papperwork
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bill

  field :session, :type => String
  field :date, :type => DateTime
  field :description, :type => String
  field :stage, :type => String
  field :chamber, :type => String

  include Sunspot::Mongoid2
  searchable do
    text :session
    time :date
    text :description
    text :stage
    text :chamber
  end
end