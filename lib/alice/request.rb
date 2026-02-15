# typed: strict
# frozen_string_literal: true

module Alice
  class Request

    #: Symbol
    attr_reader :http_method

    #: (http_method: Symbol, base_url: Alice::Types::BaseUrl) -> void
    def initialize(http_method:, base_url:)
      @http_method = http_method
      @base_url = base_url
      @path     = Alice::Types::Path.new #: Alice::Types::Path
      @params = Alice::Types::Params.new #: Alice::Types::Params
      @headers  = Alice::Types::Headers.new #: Alice::Types::Headers
      @body     = Alice::Types::Body.new #: Alice::Types::Body
    end

    #: (untyped path) -> void
    def path=(path)
      @path = Alice::Types::Path.new(path)
    end

    #: (untyped params) -> void
    def params=(params)
      @params = Alice::Types::Params.new(params)
    end

    #: (untyped headers) -> void
    def headers=(headers)
      @headers = Alice::Types::Headers.new(headers)
    end

    #: (untyped? body) -> void
    def body=(body)
      @body = Alice::Types::Body.new(body)
    end

    #: -> Hash[String, String]
    def headers
      @headers.to_h
    end

    #: -> Hash[String, untyped]
    def body
      @body.to_h
    end

    #: -> String
    def url
      qs = @params.to_s
      base = @base_url.to_s + @path.to_s
      qs.empty? ? base : "#{base}?#{qs}"
    end
  end
end
