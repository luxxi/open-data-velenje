class Visualization
  include Mongoid::Document
  belongs_to :organization

  field :name
  field :data
  field :type
end
