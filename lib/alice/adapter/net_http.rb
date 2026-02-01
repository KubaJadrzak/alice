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

          raise ArgumentError, 'only HTTP(S) URLs are supported' unless uri.is_a?(URI::HTTP)

          net_req = klass.new(uri.request_uri)

          request.headers.each { |k, v| net_req[k] = v }
          net_req['Content-Type'] ||= 'application/json'
          net_req.body = JSON.dump(request.body) if request.body

          response = perform_request(http, net_req)

          adapt_response(response)
        end

        private

        #: (Net::HTTPResponse response) -> Alice::Response
        def adapt_response(response)
          Alice::Response.new(
            status:  response.code.to_i,
            headers: response.each_header.to_h,
            body:    response.body,
          )
        end

        #: (Net::HTTP http, Net::HTTPRequest net_req) -> Net::HTTPResponse
        def perform_request(http, net_req)
          http.request(net_req)
        rescue OpenSSL::SSL::SSLError => e
          raise Alice::Error::SSLError, e
        rescue *NET_HTTP_EXCEPTIONS => e
          raise Alice::Error::ConnectionFailed, e
        rescue *TIMEOUT_EXCEPTIONS => e
          raise Alice::Error::TimeoutError, e
        end

      end
    end
  end
end
