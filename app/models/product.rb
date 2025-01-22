class Product
    attr_accessor :id, :name
  
    def initialize(id, name)
      @id = id
      @name = name
    end

    def to_json(_ = nil)
      { id: @id, name: @name }.to_json
    end
end