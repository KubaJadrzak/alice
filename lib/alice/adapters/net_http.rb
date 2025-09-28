# frozen_string_literal: true

module Alice
  module Adapters
    class NetHTTP < Adapter
      NET_HTTP_EXCEPTIONS = [
        IOError, Errno::ECONNREFUSED, Errno::ECONNRESET, SocketError,
      ].freeze

      TIMEOUT_EXCEPTIONS = [
        Net::OpenTimeout, Net::ReadTimeout, Errno::ETIMEDOUT,
      ].freeze

      def call(request)
        uri = URI.parse(request.url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'

        klass = Net::HTTP.const_get(request.method.capitalize)
        net_req = klass.new(uri)

        request.headers.each { |k, v| net_req[k] = v }
        net_req.body = request.body if request.body

        begin
          net_res = http.request(net_req)
          Response.new(
            status:  net_res.code.to_i,
            headers: net_res.each_header.to_h,
            body:    net_res.body,
          )
        rescue *TIMEOUT_EXCEPTIONS => e
          Response.new(status: 0, headers: {}, body: nil, error: Alice::Errors::TimeoutError.new(e))
        rescue *NET_HTTP_EXCEPTIONS => e
          Response.new(status: 0, headers: {}, body: nil, error: Alice::Errors::ConnectionFailed.new(e))
        rescue OpenSSL::SSL::SSLError => e
          Response.new(status: 0, headers: {}, body: nil, error: Alice::Errors::SSLError.new(e))
        end
      end
    end
  end
end
