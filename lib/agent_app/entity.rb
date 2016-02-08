module AgentApp
  class Entity < Struct.new(:id, :data, :deleted, :type)
    def initialize(data, id: nil, deleted: false, type: nil)
      super(id, data, deleted, type)
    end
  end
end
