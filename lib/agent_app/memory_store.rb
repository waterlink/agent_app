module AgentApp
  class MemoryStore < Struct.new(:_entities)
    ENTRY_TYPE = "Entry"

    def ==(other)
      return false unless other.is_a?(MemoryStore)
      self.all == other.all
    end

    def all
      entities
    end

    def entries
      entities
        .select { |e| e.type == ENTRY_TYPE }
    end

    def add(e)
      entity_map[e.id] = e
      entity_map.delete(e.id) if e.deleted
    end

    def empty?
      entities.empty?
    end

    def clear
      self._entities = nil
      @_entity_map = nil
    end

    private

    def entities
      entity_map.values
    end

    def entity_map
      @_entity_map ||= build_entity_map
    end

    def build_entity_map
      (_entities || []).each_with_object({}) do |e, m|
        m[e.id] = e
      end
    end
  end
end
