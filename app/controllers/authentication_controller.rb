require 'json'
require 'securerandom'
require 'bcrypt'
require_relative '../modules/response_module'

class AuthenticationController

  def self.call(env, sessions, users)
    request = Rack::Request.new(env)
    if request.post?
      data = JSON.parse(request.body.read)
      user = data['username']
      password = data['password']

      if user.nil? || password.nil?
        ResponseModule.response(400, { error: 'Invalid request' }.to_json)
      elsif BCrypt::Password.new(users[user]) == password
        token = SecureRandom.hex(16)
        sessions[token] = true
        ResponseModule.response(200, { token: token }.to_json)
      else
        ResponseModule.response(401, { error: 'Invalid credentials' }.to_json)
      end
    else
      ResponseModule.response(405, { error: 'Method not allowed' }.to_json)
    end
  end

  def self.call_logout(env, sessions, users)
    request = Rack::Request.new(env)
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
    sessions.delete(token)
    ResponseModule.response(200, { message: 'Logged out' }.to_json)
  end
end
