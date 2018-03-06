class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    payload = @organization.payload ? update(data) : create(data)

    if payload.is_a?(Array)
      payload = payload.reduce(Hash.new, :merge)
    end

    @organization.update!(payload: payload)
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


  def update(data)
    payload = create(data)

    if payload.is_a?(Array)
      payload = payload.reduce(Hash.new, :merge)
    end

    @organization.payload.merge(payload) do |_, o, n|
      if o.is_a?(Array)
        o.each_with_index.map {|x, i| x.merge(n[i]) {|_,d,e| d.blank? ? e : d}}
      else
        n.blank? ? o : n
      end
    end
  end

  def attribute(value)
    {
      "type": "",
      "description": "",
      "value": value
    }
  end
end
