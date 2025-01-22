require 'rack/test'
require_relative '../config/application'

RSpec.describe 'Products API' do
  include Rack::Test::Methods

  def app
    RackApp
  end

  let(:auth_headers) do
    post '/auth', { username: 'admin', password: 'password123' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    token = JSON.parse(last_response.body)['token']
    { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
  end

  it 'creates a product asynchronously and verifies its existence after 5 seconds' do
    post '/products', { id: 1, name: 'Laptop' }.to_json, auth_headers
    expect(last_response.status).to eq(202)

    sleep 6

    get '/products', {}, auth_headers
    expect(last_response.status).to eq(200)
    
    products = JSON.parse(last_response.body)
    product_names = products.map { |p| p['name'] }
    expect(product_names).to include('Laptop')
  end

  it 'returns an error when trying to access products without authentication' do
    get '/products'
    expect(last_response.status).to eq(401)
  end
end