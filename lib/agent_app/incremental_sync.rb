module AgentApp
  # job: IncrementalSync represents a use case of incremental updates of data
  class IncrementalSync
    def initialize(source, store, nxt_store)
      @source = source
      @store = store
      @nxt_store = nxt_store
    end

    def call
      nxt = source.fetch_next(nxt_store.fetch) do |e|
        store.add(e)
      end
      nxt_store.store(nxt)
    end

    private

    attr_reader :source, :store, :nxt_store
  end
end
