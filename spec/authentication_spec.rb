require 'rack/test'
require_relative '../config/application'

RSpec.describe 'Authentication API' do
  include Rack::Test::Methods

  def app
    RackApp
  end

  it 'authenticates successfully with correct credentials' do
    post '/auth', { username: 'admin', password: 'password123' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to have_key('token')
  end

  it 'fails authentication with incorrect credentials' do
    post '/auth', { username: 'admin', password: 'password' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    expect(last_response.status).to eq(401)
  end

  it 'returns 405 for unsupported HTTP methods' do
    get '/auth'
    expect(last_response.status).to eq(405)
  end
end