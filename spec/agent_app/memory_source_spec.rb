require "agent_app/memory_source"

module AgentApp
  RSpec.describe MemorySource do
    let(:a) { Entity.new(double("Data"), id: 1) }
    let(:b) { Entity.new(double("Data"), id: 2) }
    let(:c) { Entity.new(double("Data"), id: 3) }
    let(:d) { Entity.new(double("Data"), id: 2) }
    let(:e) { Entity.new(double("Data"), id: 3, deleted: true) }

    it "can be created as empty" do
      expect(MemorySource.new)
        .to eq(MemorySource.new)
    end

    it "can be created with some entities" do
      expect(MemorySource.new([a, b]))
        .to eq(MemorySource.new([a, b]))

      expect(MemorySource.new([a]))
        .not_to eq(MemorySource.new([a, b]))
    end

    it "allows to iterate over all entities" do
      got = []
      MemorySource.new.fetch_entities { |e| got << e }
      expect(got).to eq([])

      got = []
      MemorySource.new([a, b]).fetch_entities { |e| got << e }
      expect(got).to eq([a, b])
    end

    it "allows to iterate over new entities" do
      m = MemorySource.new([a, b])
      nxt = m.fetch_entities { |x| nil }

      got = []
      m._entities = [a, b, c, d]
      nxt = m.fetch_next(nxt) { |x| got << x }
      expect(got).to eq([c, d])

      got = []
      m._entities << e
      nxt = m.fetch_next(nxt) { |x| got << x }
      expect(got).to eq([e])
    end
  end
end
