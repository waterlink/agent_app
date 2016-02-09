require "agent_app/api/entries_view"
require "agent_app/entries_response"

module AgentApp
  module Api
    RSpec.describe EntriesView do
      let(:response) { EntriesResponse.new([]) }

      let(:e1) { { "some" => "data", "is" => "here" } }
      let(:e2) { { "other" => "data", "is" => "irrelevant" } }

      it "renders an empty collection, when data is empty" do
        expect(JSON.parse(EntriesView.new(response).render))
          .to eq({
          "sys" => { "type" => "Array" },
          "total" => 0,
          "skip" => 0,
          "limit" => 100,
          "items" => [],
        })
      end

      it "renders a collection, when there is some data" do
        response = EntriesResponse.new([
          Entity.new(e1),
          Entity.new(e2),
        ])

        expect(JSON.parse(EntriesView.new(response).render))
          .to eq({
          "sys" => { "type" => "Array" },
          "total" => 2,
          "skip" => 0,
          "limit" => 100,
          "items" => [e1, e2],
        })
      end
    end
  end
end
