module AgentApp
  # job: FetchEntries represents a use case for obtaining entities of type
  # Entry
  class FetchEntries
    def initialize(store)
      @store = store
    end

    def call
      EntriesResponse.new(store.entries)
    end

    private

    attr_reader :store
  end
end
