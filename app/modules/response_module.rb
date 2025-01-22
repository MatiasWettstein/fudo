require 'zlib'
require 'stringio'

module ResponseModule 
    def self.response(status, body, headers = {})
        response = Rack::Response.new
        response.status = status 

        if headers['Content-Encoding'] == 'gzip'
            io = StringIO.new
            gz = Zlib::GzipWriter.new(io)
            gz.write(body)
            gz.close
            body = io.string
        end

        response.write(body)
        headers.each { |key, value| response[key] = value }
        return response.finish
    end
end