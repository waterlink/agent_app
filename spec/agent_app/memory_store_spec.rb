require "agent_app/memory_store"

module AgentApp
  RSpec.describe MemoryStore do
    it "can be created" do
      expect(MemoryStore.new)
        .to eq(MemoryStore.new)
    end

    it "is possible to fetch all entities" do
      a = Entity.new(double("Data"), id: 1)
      b = Entity.new(double("Data"), id: 2)

      expect(MemoryStore.new([]).all).to eq([])
      expect(MemoryStore.new.all).to eq([])
      expect(MemoryStore.new([a, b]).all).to eq([a, b])
    end

    it "is possible to save entities" do
      a = Entity.new(double("Data"), id: 1)

      m = MemoryStore.new
      m.add(a)
      expect(m).to eq(MemoryStore.new([a]))
    end

    it "is possible to update existing entity" do
      a = Entity.new(double("Data"), id: 1)
      new_a = Entity.new(double("Data"), id: 1)

      m = MemoryStore.new([a])
      m.add(new_a)
      expect(m).to eq(MemoryStore.new([new_a]))
    end

    it "is possible to remove existing entity" do
      a = Entity.new(double("Data"), id: 1)
      rm_a = Entity.new(double("Data"), id: 1, deleted: true)

      m = MemoryStore.new([a])
      m.add(rm_a)
      expect(m).to eq(MemoryStore.new([]))
    end

    it "is possible to tell if store is empty or not" do
      a = Entity.new(double("Data"), id: 1)
      b = Entity.new(double("Data"), id: 2)

      expect(MemoryStore.new).to be_empty
      expect(MemoryStore.new([])).to be_empty
      expect(MemoryStore.new([a, b])).not_to be_empty
    end
  end
end