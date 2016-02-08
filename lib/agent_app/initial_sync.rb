module AgentApp
  # job: InitialSync represents a use case of initial population of data
  class InitialSync
    def initialize(source, store)
      @source = source
      @store = store
    end

    def call
      return unless store.empty?
      source.fetch_entities do |e|
        store.add(e)
      end
    end

    private

    attr_reader :source, :store
  end
end
