module Organicity
  class PushService
    def initialize(organization_id)
      @organization = Organization.find(organization_id)
    end

    def push!
      metadata = {
	       id: "urn:oc:entity:velenje:Test:testnipodatki:#{SecureRandom.uuid}",
	       type: "urn:oc:entityType:velenjedata",
         TimeInstant: {
           type: "urn:oc:attributeType:ISO8601",
           value: Time.zone.now,
           metadata: {}
         },
         location: {
           type: "geo:point",
           value: "46.358002, 15.119371",
           metadata: {}
         }
        }
    def update!
      raise ArgumentError unless @organization.oc_urn

      metadata = {
         TimeInstant: {
           type: "urn:oc:attributeType:ISO8601",
           value: Time.zone.now,
           metadata: {}
         },
         location: {
           type: "geo:point",
           value: "46.358002, 15.119371",
           metadata: {}
         }
        }


      payload = metadata.merge(generate_structure(@organization.payload, ""))
      ::Api::Organicity::Asset.new.update(@organization.oc_urn, payload)
    end

    private

    def generate_structure(payload, path)
      hash = Hash.new
      payload.map do |key, value|
        if value.is_a?(Hash)
          if (value.keys & ["type", "description", "value"]).any?
            hash.merge!(path_format(path, key) => value.except(:description))
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
  end
end
