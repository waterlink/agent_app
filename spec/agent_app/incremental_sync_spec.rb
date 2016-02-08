require "agent_app/incremental_sync"
require "agent_app/nxt_memory_store"
require "agent_app/memory_store"
require "agent_app/memory_source"
require "agent_app/entity"

module AgentApp
  RSpec.describe IncrementalSync do
    let(:a) { Entity.new(double("Data"), id: 1) }
    let(:b) { Entity.new(double("Data"), id: 2) }
    let(:c) { Entity.new(double("Data"), id: 3) }
    let(:change_b) { Entity.new(double("Data"), id: 2) }
    let(:remove_c) { Entity.new(double("Data"), id: 3, deleted: true) }

    let(:source) { MemorySource.new([a, b]) }
    let(:store) { MemoryStore.new([a, b]) }
    let(:nxt_store) { NxtMemoryStore.new }

    before do
      nxt = source.fetch_entities
      nxt_store.store(nxt)
    end

    it "does nothing when there are no updates" do
      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([a, b])
    end

    it "can add new entities from updates" do
      source = MemorySource.new([a, b, c])
      store = MemoryStore.new([a, b])
      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([a, b, c])
    end

    it "can change existing entities from updates" do
      source = MemorySource.new([a, b, change_b])
      store = MemoryStore.new([a, b])
      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([a, change_b])
    end

    it "can remove existing entities from updates" do
      source = MemorySource.new([a, b, c, remove_c])
      store = MemoryStore.new([a, b, c])
      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([a, b])
    end

    it "should be able to continue (i.e.: stores next nxt)" do
      source = MemorySource.new([a, b, c])
      store = MemoryStore.new([b])

      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([b, c])

      source = MemorySource.new([a, b, c, a])
      store = MemoryStore.new([b])
      IncrementalSync.new(source, store, nxt_store).call
      expect(store.all).to eq([b, a])
    end
  end
end
