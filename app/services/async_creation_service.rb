require 'concurrent'
require 'securerandom'
require_relative '../models/product'
require_relative '../controllers/products_controller'

class AsyncCreationService
  def initialize
    @products = []
  end

  def add_product(name)
    id = SecureRandom.uuid
    Concurrent::ScheduledTask.execute(5) do
      @products << {id: id, name: name}
    end
    id
  end

  def find_product(id)
    @products.find { |product| product.id == id }
  end

  def list_products
    @products
  end
end