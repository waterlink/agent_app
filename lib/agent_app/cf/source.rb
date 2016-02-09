require "net/http"

module AgentApp
  module Cf
    class Source
      def initialize(endpoint, space_id, access_token, type)
        @endpoint, @space_id, @access_token, @type =
          endpoint, space_id, access_token, type
      end

      def fetch_entities(&blk)
        fetch_from(generate_url, &blk)
      end

      def fetch_next(nxt, &blk)
        fetch_from(nxt, &blk)
      end

      private

      attr_reader :endpoint, :space_id, :access_token, :type

      def fetch_from(url)
        while url
          data = data_from(url)

          items_from(data).each do |item|
            yield(entity_from(item, item.fetch("sys", {})))
          end

          url = data["nextPageUrl"]
        end
        data["nextSyncUrl"]
      end

      def data_from(url)
        JSON.parse(Net::HTTP.get(URI(url)))
      end

      def items_from(data)
        data.fetch("items", [])
      end

      def generate_url
        "#{endpoint}/spaces/#{space_id}/sync?access_token=#{access_token}&initial=true&type=#{type}"
      end

      def entity_from(entity_data, sys)
        Entity.new(
          entity_data,
          id: sys["id"],
          type: sys["type"],
          deleted: sys.has_key?("deletedAt"),
        )
      end
    end
  end
end
