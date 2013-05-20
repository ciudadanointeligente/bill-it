class Modification
  include Mongoid::Document

  embedded_in :bill

  field :description, :type => String
end