require "agent_app/initial_sync"
require "agent_app/memory_source"
require "agent_app/memory_store"

module AgentApp
  RSpec.describe InitialSync do
    it "does initial sync" do
      a = Entity.new(double("Data"), id: 1)
      b = Entity.new(double("Data"), id: 2)

      source = MemorySource.new
      store = MemoryStore.new
      InitialSync.new(source, store).call
      expect(store.all).to eq([])

      source = MemorySource.new([a, b])
      store = MemoryStore.new
      InitialSync.new(source, store).call
      expect(store.all).to eq([a, b])
    end

    it "does nothing when store is not empty" do
      a = Entity.new(double("Data"), id: 1)
      b = Entity.new(double("Data"), id: 2)

      source = MemorySource.new([a, b])
      store = MemoryStore.new([b])
      InitialSync.new(source, store).call
      expect(store.all).to eq([b])
    end
  end
end
