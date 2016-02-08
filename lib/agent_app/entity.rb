module AgentApp
  class Entity < Struct.new(:id, :data, :deleted)
    def initialize(data, id: nil, deleted: false)
      super(id, data, deleted)
    end
  end
end
