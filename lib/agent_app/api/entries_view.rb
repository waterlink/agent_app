module AgentApp
  module Api
    class EntriesView
      def initialize(response)
        @response = response
      end

      def render
        {
          sys: { type: "Array" },
          total: response.entries.size,
          skip: 0,
          limit: 100,
          items: response.entries.map(&:data),
        }.to_json
      end

      private

      attr_reader :response
    end
  end
end
