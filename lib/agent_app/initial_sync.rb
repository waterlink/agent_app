module AgentApp
  # job: InitialSync represents a use case of initial population of data
  class InitialSync
    def initialize(source, store, nxt_store)
      @source = source
      @store = store
      @nxt_store = nxt_store
    end

    def call
      return unless store.empty?
      nxt_store.store(fetch_entities)
    end

    private

    attr_reader :source, :store, :nxt_store

    def fetch_entities
      source.fetch_entities do |e|
        store.add(e)
      end
    end
  end
end
