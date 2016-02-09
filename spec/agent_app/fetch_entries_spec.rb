require "agent_app/fetch_entries"
require "agent_app/memory_store"
require "agent_app/entries_response"
require "agent_app/entity"

module AgentApp
  RSpec.describe FetchEntries do
    let(:a) { Entity.new(double("Data"), id: 1, type: "Entry") }
    let(:b) { Entity.new(double("Data"), id: 2, type: "Entry") }
    let(:c) { Entity.new(double("Data"), id: 3, type: "Asset") }

    let(:store) { MemoryStore.new }

    it "returns an empty EntriesResponse object" do
      expect(FetchEntries.new(store).call)
        .to eq(EntriesResponse.new([]))
    end

    it "returns some entries in EntriesResponse object" do
      store = MemoryStore.new([a, b])

      expect(FetchEntries.new(store).call)
        .to eq(EntriesResponse.new([a, b]))
    end

    it "returns only entities with type=Entry" do
      store = MemoryStore.new([a, b, c])

      expect(FetchEntries.new(store).call)
        .to eq(EntriesResponse.new([a, b]))
    end
  end
end
