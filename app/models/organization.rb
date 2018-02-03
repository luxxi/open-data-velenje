class Organization
  include Mongoid::Document
  field :name
  field :slug
  field :url
  field :payload
  field :documentation
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  validate :name, presence: true
  validate :url, presence: true
  validate :created_at, presence: true
  validate :updated_at, presence: true
end
