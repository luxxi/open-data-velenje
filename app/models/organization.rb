class Organization
  include Mongoid::Document
  include Mongoid::Slug

  field :name
  slug :name, history: true
  field :url
  field :payload
  field :documentation
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
end
