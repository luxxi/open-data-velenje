module Organicity
  class PushService
    def initialize(organization_id)
      @organization = Organization.find(organization_id)
    end

    def push!
      @organization.oc_urn ? update : create
    end

    private

    def create
      oc_urn = "urn:oc:entity:velenje:opendata:#{@organization.slug&.first}:#{SecureRandom.uuid}"
      metadata = {
	       id: oc_urn,
	       type: "urn:oc:entityType:velenjedata"
        }

      metadata.merge!(location_field(@organization.oc_location)) if @organization.oc_template
      payload = metadata.merge(generate_structure(@organization.payload, ""))
      begin
        ::Api::Organicity::Asset.new.create(payload)
      rescue Exception => e
        puts e
      else
        @organization.update!(oc_urn: oc_urn)
      end
    end


    def update
      raise ArgumentError unless @organization.oc_urn
      payload = timestamp_field.merge(generate_structure(@organization.payload, ""))
      payload.merge!(location_field(@organization.oc_location)) if @organization.oc_template
      ::Api::Organicity::Asset.new.update(@organization.oc_urn, payload)
    end

    def generate_structure(payload, path)
      hash = Hash.new
      payload.map do |key, value|
        if value.is_a?(Hash)
          if (value.keys & ["attr_type", "attr_description", "attr_value"]).any?
            obj = {
              type: value["attr_type"],
              value: value["attr_value"].is_a?(String) ? value["attr_value"].tr('()', '') : value["attr_value"]
            }
            hash.merge!(path_format(path, key) => obj)
          else
            hash.merge!(generate_structure(value, path_format(path, key)))
          end
        elsif value.is_a?(Array)
          value.each_with_index do |element, i|
            hash.merge!(generate_structure(element, "#{path_format(path, key)}|#{i}"))
          end
        end
      end
      hash
    end

    def path_format(path, key)
      path.empty? ? key : "#{path}|#{key}"
    end

    def location_field(value)
      {
        location: {
          type: "geo:point",
          value: value,
          metadata: {}
        }
      }
    end

    def timestamp_field
      {
        TimeInstant: {
          type: "urn:oc:attributeType:ISO8601",
          value: Time.zone.now,
          metadata: {}
        }
      }
    end
  end
end
