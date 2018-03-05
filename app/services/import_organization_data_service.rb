class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    # payload = @organization.payload ? update : create(data)
    # hash=Hash.new
    # data.map do |key, value|
    #   if value.is_a?(Hash)
    #     hash[key] = create(value)
    #   else
    #     hash = hash.merge(attribute(key, value))
    #   end
    # end
    @organization.update!(payload: create(data).reduce(Hash.new, :merge))
  end

  private

  def create(hash)
    a=Array.new
    h=Hash.new
    hash.map do |key, value|
      if value.is_a?(Hash)
        h[key] = create(value)
      else
        h = h.merge(attribute(key, value))
        a<<attribute(key, value)
      end
    end

    a<<h unless h.empty?
    if a.size == 1
      return h
    else
      return a
    end
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
