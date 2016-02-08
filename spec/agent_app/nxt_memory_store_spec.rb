require "agent_app/nxt_memory_store"

module AgentApp
  RSpec.describe NxtMemoryStore do
    it "allows to store and retrieve nxt value" do
      m = NxtMemoryStore.new
      expect(m.fetch).to eq(nil)

      nxt = double("nxt")
      m.store(nxt)
      expect(m.fetch).to eq(nxt)
      expect(m.fetch).to eq(nxt)

      other = double("other nxt")
      m.store(other)
      expect(m.fetch).to eq(other)
      expect(m.fetch).to eq(other)
    end
  end
end
