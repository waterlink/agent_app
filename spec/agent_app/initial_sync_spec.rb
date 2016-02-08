require "agent_app/initial_sync"
require "agent_app/memory_source"
require "agent_app/memory_store"

module AgentApp
  RSpec.describe InitialSync do
    let(:a) { Entity.new(double("Data"), id: 1) }
    let(:b) { Entity.new(double("Data"), id: 2) }

    let(:source) { MemorySource.new }
    let(:store) { MemoryStore.new }
    let(:nxt_store) { NxtMemoryStore.new }

    it "does nothing when source is empty" do
      InitialSync.new(source, store, nxt_store).call
      expect(store.all).to eq([])
    end

    it "does initial sync when source is not empty" do
      source = MemorySource.new([a, b])
      InitialSync.new(source, store, nxt_store).call
      expect(store.all).to eq([a, b])
    end

    it "does nothing when store is not empty" do
      source = MemorySource.new([a, b])
      store = MemoryStore.new([b])
      InitialSync.new(source, store, nxt_store).call
      expect(store.all).to eq([b])
    end

    it "stores nxt" do
      source = MemorySource.new([a, b])
      InitialSync.new(source, store, nxt_store).call
      expect(nxt_store.fetch).to eq(2)
    end
  end
end
