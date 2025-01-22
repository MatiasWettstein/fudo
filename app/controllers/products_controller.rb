require 'json'
require_relative '../models/product'
require_relative '../services/async_creation_service'
require_relative '../modules/response_module'
class ProductsController
  @store = AsyncCreationService.new

  def self.call(env, sessions)
    request = Rack::Request.new(env)
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
    if sessions[token].nil?
      return ResponseModule.response(401, { error: 'Invalid credentials' }.to_json)
    end

    headers = {}
    headers['Content-Encoding'] = 'gzip' if request.env['HTTP_ACCEPT_ENCODING']&.include?('gzip')

    case request.request_method
    when 'POST'
      data = JSON.parse(request.body.read)
      @store.add_product(data['name'])
      ResponseModule.response(202, 'Product creation started', headers)
    when 'GET'
      ResponseModule.response(200, @store.list_products.to_json, headers)
    else
      ResponseModule.response(405, { error: 'Method Not Allowed' }.to_json, headers)
    end
  end

  def self.call_by_id(env, sessions, id)
    request = Rack::Request.new(env)
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last

    if !sessions[token]
      return ResponseModule.response(401, { error: 'Invalid credentials' }.to_json)
    end

    headers = {}
    headers['Content-Encoding'] = 'gzip' if request.env['HTTP_ACCEPT_ENCODING']&.include?('gzip')

    product = @store.find_product(id)
    if product
      ResponseModule.response(200, product.to_json, headers)
    else
      ResponseModule.response(404, { error: 'Product not found' }.to_json, headers)
    end
  end
end
