require "agent_app/cf/source"
require "agent_app/entity"

module AgentApp
  module Cf
    RSpec.describe Source do
      let(:endpoint) { ENV.fetch("CF_SOURCE_ENDPOINT") }
      let(:space_id) { ENV.fetch("CF_SOURCE_SPACE_ID") }
      let(:token) { ENV.fetch("CF_SOURCE_TOKEN") }
      let(:type) { "all" }

      let(:url) { "#{endpoint}/spaces/#{space_id}/sync?access_token=#{token}&initial=true&type=#{type}" }

      subject(:source) { Source.new(endpoint, space_id, token, type) }

      let(:e1) { { "sys" => { "type" => "Entry", "id" => "abcdef25" }, "data" => "the data" } }
      let(:e2) { { "sys" => { "type" => "Asset", "id" => "abcdef26" }, "data" => "no data" } }
      let(:e3) { { "sys" => { "type" => "Entry", "id" => "abcdef27" }, "data" => "some data" } }

      let(:d2) { { "sys" => { "type" => "Asset", "id" => "abcdef26", "deletedAt" => "2014-08-11T08:30:42.559Z" }, "data" => "no data" } }

      describe "#fetch_entities" do
        it "yields to empty, when response is empty" do
          stub_request(:get, url).to_return(body: {
            items: [],
          }.to_json)

          got = []
          source.fetch_entities { |e| got << e }

          expect(got).to eq([])
        end

        it "yields to items, when response is not empty" do
          stub_request(:get, url).to_return(body: {
            items: [ e1, e2 ],
          }.to_json)

          got = []
          source.fetch_entities { |e| got << e }

          expect(got).to eq([
            Entity.new(e1, id: "abcdef25", type: "Entry"),
            Entity.new(e2, id: "abcdef26", type: "Asset"),
          ])
        end

        it "follows the nextPageUrl" do
          stub_request(:get, url).to_return(body: {
            items: [ e1, e2 ],
            nextPageUrl: "#{endpoint}/the/next/page/url",
          }.to_json)

          stub_request(:get, "#{endpoint}/the/next/page/url").to_return(body: {
            items: [ e3 ],
          }.to_json)

          got = []
          source.fetch_entities { |e| got << e }

          expect(got).to eq([
            Entity.new(e1, id: "abcdef25", type: "Entry"),
            Entity.new(e2, id: "abcdef26", type: "Asset"),
            Entity.new(e3, id: "abcdef27", type: "Entry"),
          ])
        end

        it "returns nxt" do
          stub_request(:get, url).to_return(body: {
            items: [ e1, e2 ],
            nextSyncUrl: "#{endpoint}/the/next/sync/url",
          }.to_json)

          nxt = source.fetch_entities {}
          expect(nxt).to eq("#{endpoint}/the/next/sync/url")
        end
      end

      describe "#fetch_next" do
        it "yields to empty if response is empty" do
          nxt = "#{endpoint}/the/sync/url"
          stub_request(:get, nxt)
            .to_return(body: { items: [] }.to_json)

          got = []
          source.fetch_next(nxt) { |e| got << e }

          expect(got).to eq([])
        end

        it "yields to items if response has them" do
          nxt = "#{endpoint}/the/sync/url"
          stub_request(:get, nxt)
            .to_return(body: { items: [e1, e2] }.to_json)

          got = []
          source.fetch_next(nxt) { |e| got << e }

          expect(got).to eq([
            Entity.new(e1, id: "abcdef25", type: "Entry"),
            Entity.new(e2, id: "abcdef26", type: "Asset"),
          ])
        end

        it "handles Deletion correctly" do
          nxt = "#{endpoint}/the/sync/url"
          stub_request(:get, nxt)
            .to_return(body: { items: [e1, d2] }.to_json)

          got = []
          source.fetch_next(nxt) { |e| got << e }

          expect(got).to eq([
            Entity.new(e1, id: "abcdef25", type: "Entry"),
            Entity.new(d2, id: "abcdef26", type: "Asset", deleted: true),
          ])
        end

        it "follows the nextPageUrl" do
          nxt = "#{endpoint}/the/sync/url"

          stub_request(:get, nxt).to_return(body: {
            items: [ e1, e2 ],
            nextPageUrl: "#{endpoint}/the/next/page/url",
          }.to_json)

          stub_request(:get, "#{endpoint}/the/next/page/url").to_return(body: {
            items: [ e3 ],
          }.to_json)

          got = []
          source.fetch_next(nxt) { |e| got << e }

          expect(got).to eq([
            Entity.new(e1, id: "abcdef25", type: "Entry"),
            Entity.new(e2, id: "abcdef26", type: "Asset"),
            Entity.new(e3, id: "abcdef27", type: "Entry"),
          ])
        end

        it "returns nxt" do
          nxt = "#{endpoint}/the/sync/url"

          stub_request(:get, nxt).to_return(body: {
            items: [ e1, e2 ],
            nextSyncUrl: "#{endpoint}/the/next/sync/url",
          }.to_json)

          next_nxt = source.fetch_next(nxt) {}
          expect(next_nxt).to eq("#{endpoint}/the/next/sync/url")
        end
      end
    end
  end
end
