class ImportOrganizationDataService
  def initialize(organization_id)
    @organization = Organization.find(organization_id)
  end

  def import!
    payload = @organization.payload ? update(fetch_data) : create(fetch_data)
    @organization.update!(payload: payload)
    Organicity::PushService.new(@organization).push! if @organization.oc_sync
  end

  def fetch_data
    json_payload = case @organization.fetch_type
    when "url - json"
      HTTParty.get(@organization.url, verify: false).parsed_response
    when "url - plain"
      response = HTTParty.get(@organization.url, verify: false).parsed_response
      doc = Nokogiri::HTML(response)
      JSON.parse(doc.at('body').content)
    when "api - get"
      HTTParty.get(
        @organization.url,
        body: @organization.fetch_metadata.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    when "api - post"
      HTTParty.post(
        @organization.url,
        body: @organization.fetch_metadata.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
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
