class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    # payload = @organization.payload ? update : create(data)
    hash=Hash.new
    data.map do |key, value|
      if value.is_a?(Hash)
        hash[key] = create(value)
      else
        hash = hash.merge(attribute(key, value))
      end
    end
    @organization.update!(payload: hash)
  end

  private

  def create(hash)
    a=Array.new
    h=Hash.new
    hash.map do |key, value|
      if value.is_a?(Hash)
        h[key] = create(value)
      else
        a<<attribute(key, value)
      end
    end
    a<<h unless h.empty?
    return a
  end

  def update

  end

  def attribute(name, value)
    {
      "name": name,
      "type": "",
      "description": "",
      "value": value
    }
  end
end
