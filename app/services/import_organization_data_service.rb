class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    # payload = @organization.payload ? update : create(data)
    @organization.update!(payload: create(data))
  end

  private
  def create(hash)
    hash.map do |key, value|
      if value.is_a?(Hash)
        { "#{key}" => create(value) }
      else
        attribute(key, value)
      end
    end
  end

  def update

  end

  def attribute(name, value)
    {
      "name" => name,
      "type" => "",
      "value" => value
    }
  end
end
