module AgentApp
  class MemorySource < Struct.new(:_entities)
    def fetch_entities(&blk)
      entities.each(&blk)
      entities.size
    end

    def fetch_next(nxt, &blk)
      entities[nxt..-1].each(&blk)
      entities.size
    end

    private

    def entities
      self._entities ||= []
    end
  end
end
