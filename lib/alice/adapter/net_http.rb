# typed: strict
# frozen_string_literal: true

module Alice
  module Adapter
    class NetHTTP < Base
      class << self

        NET_HTTP_EXCEPTIONS = [
          IOError, Errno::ECONNREFUSED, Errno::ECONNRESET, SocketError,
        ].freeze

        TIMEOUT_EXCEPTIONS = [
          Net::OpenTimeout, Net::ReadTimeout, Errno::ETIMEDOUT,
        ].freeze

        # @override
        #: (Alice::Request request) -> Alice::Response
        def call(request)
          uri = URI.parse(request.url)

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'

          klass = Net::HTTP.const_get(request.method.capitalize)
          net_req = klass.new(uri)

          request.headers.each { |k, v| net_req[k] = v }
          net_req.body = request.body if request.body

        end
      end
    end
  end
end
