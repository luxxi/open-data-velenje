class Organization
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :name
  slug :name, history: true
  field :url
  field :payload
  field :documentation
end
