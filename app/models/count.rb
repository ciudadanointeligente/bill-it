class Count
  include Mongoid::Document
  field :option, type: String
  field :value, type: String
end
