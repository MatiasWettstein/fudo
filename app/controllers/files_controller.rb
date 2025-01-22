require_relative '../modules/response_module'

class FilesController
    def self.call(file, content_type, cache_control)
        if File.exist?(file)
            ResponseModule.response(200, File.read(file), { 'Content-Type' => content_type, 'Cache-Control' => cache_control })
        else
            ResponseModule.response(404, 'Not Found')
        end
    end
end