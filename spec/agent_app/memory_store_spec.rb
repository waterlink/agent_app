require "agent_app/memory_store"

module AgentApp
  RSpec.describe MemoryStore do
    let(:a) { Entity.new(double("Data"), id: 1) }
    let(:b) { Entity.new(double("Data"), id: 2) }

    it "can be created" do
      expect(MemoryStore.new)
        .to eq(MemoryStore.new)
    end

    it "is possible to fetch all entities" do
      expect(MemoryStore.new([]).all).to eq([])
      expect(MemoryStore.new.all).to eq([])
      expect(MemoryStore.new([a, b]).all).to eq([a, b])
    end

    it "is possible to save entities" do
      m = MemoryStore.new
      m.add(a)
      expect(m).to eq(MemoryStore.new([a]))
    end

    it "is possible to update existing entity" do
      new_a = Entity.new(double("Data"), id: 1)

      m = MemoryStore.new([a])
      m.add(new_a)
      expect(m).to eq(MemoryStore.new([new_a]))
    end

    it "is possible to remove existing entity" do
      rm_a = Entity.new(double("Data"), id: 1, deleted: true)

      m = MemoryStore.new([a])
      m.add(rm_a)
      expect(m).to eq(MemoryStore.new([]))
    end

    it "is possible to tell if store is empty or not" do
      expect(MemoryStore.new).to be_empty
      expect(MemoryStore.new([])).to be_empty
      expect(MemoryStore.new([a, b])).not_to be_empty
    end

    it "is possible to clear it" do
      m = MemoryStore.new([a, b])
      m.clear
      expect(m).to eq(MemoryStore.new)
    end
  end
end
