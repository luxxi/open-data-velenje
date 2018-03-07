class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    @organization.update!(payload: create(data))
  end

  private

  def create(hash)
    a=Array.new
    h=Hash.new
    hash.map do |key, value|
      if value.is_a?(Hash)
        h[key] = create(value)
      elsif value.is_a?(Array)
        h[key] = []
        value.each do |v|
          h[key] << create(v)
        end
      else
        h[key]=attribute(value)
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

  def attribute(value)
    {
      "type": "",
      "description": "",
      "value": value
    }
  end
end
