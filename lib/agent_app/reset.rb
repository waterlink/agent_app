module AgentApp
  # job: Reset represents a use case for clearing all stored data
  class Reset
    def initialize(store, nxt_store)
      @store = store
      @nxt_store = nxt_store
    end

    def call
      store.clear
      nxt_store.clear
    end

    private

    attr_reader :store, :nxt_store
  end
end
