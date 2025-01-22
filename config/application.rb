require 'rack'
require 'bcrypt'
require_relative '../app/controllers/authentication_controller'
require_relative '../app/controllers/products_controller'
require_relative '../app/controllers/files_controller'
require_relative '../app/modules/response_module'

class RackApp
  USERS = { 'admin' => '$2a$12$t.Rj29jn4WVMtEZKURmH7exT3oD5xfFluSgG.K/AR2Y5/5IbAn.v6' }
  @sessions = {}
  
  def self.call(env)
    request = Rack::Request.new(env)
    case request.path
               when '/auth' then AuthenticationController.call(env, @sessions, USERS)
               when '/logout' then AuthenticationController.call_logout(env, @sessions, USERS)
               when '/products' then ProductsController.call(env, @sessions)
               when %r{/products/(.+)} then ProductsController.call_by_id(env, @sessions, $1)
               when '/openapi' then FilesController.call('./public/openapi.yaml', 'text/yaml', 'no-cache')
               when '/AUTHORS' then FilesController.call('./public/AUTHORS', 'text/plain', 'max-age=86400')
               else 
                ResponseModule.response(404, 'Not Found')
    end
  end
end
