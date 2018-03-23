class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!(data)
    payload = @organization.payload ? update(data) : create(data)
    @organization.update!(payload: payload)
    Organicity::PushService.new(@organization).push! if @organization.verified
  end

  def parse_payload
    url = @organization.url
    response = HTTParty.get(url, verify: false).parsed_response
    if response.class == Hash
      json_payload = response
    else
      doc = Nokogiri::HTML(response)
      json_payload = JSON.parse(doc.at('body').content)
    end
    json_payload.delete("timeseries") if @organization.name == 'Komunala Velenje'
    json_payload
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
    @organization.payload.deep_merge(payload) do |_, o, n|
      if o.is_a?(Array)
        o.each_with_index.map {|x, i| x.deep_merge(n[i]) {|_,d,e| d.blank? ? e : d}}
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
