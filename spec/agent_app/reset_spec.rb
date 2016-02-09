require "agent_app/reset"
require "agent_app/memory_store"
require "agent_app/nxt_memory_store"
require "agent_app/entity"

module AgentApp
  RSpec.describe Reset do
    let(:a) { Entity.new(double("Data"), id: 1) }
    let(:b) { Entity.new(double("Data"), id: 2) }

    let(:store) { MemoryStore.new([a, b]) }
    let(:nxt_store) { NxtMemoryStore.new }

    before do
      nxt_store.store(3)
    end

    it "clears store" do
      Reset.new(store, nxt_store).call
      expect(store).to eq(MemoryStore.new)
    end

    it "clears nxt_store" do
      Reset.new(store, nxt_store).call
      expect(nxt_store.fetch).to eq(nil)
    end
  end
end
