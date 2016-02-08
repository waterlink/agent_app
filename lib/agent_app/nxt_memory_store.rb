module AgentApp
  class NxtMemoryStore
    def initialize
      @nxt = nil
    end

    def fetch
      @nxt
    end

    def store(nxt)
      @nxt = nxt
    end

    def clear
      store(nil)
    end
  end
end
