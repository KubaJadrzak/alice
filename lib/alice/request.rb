# typed: strict
# frozen_string_literal: true

module Alice
  class Request

    #: Symbol
    attr_reader :http_method

    #: String
    attr_reader :base_url

    #: String
    attr_reader :path

    #: Hash[String, String]?
    attr_reader :params

    #: Hash[String, String]
    attr_reader :headers

    #: Hash[String, String]?
    attr_reader :body

    #: (http_method: Symbol, base_url: String, path: untyped, params: untyped, headers: untyped, body: untyped) -> void
    def initialize(http_method:, base_url:, path:, params:, headers:, body:)
      @http_method = http_method
      @base_url = base_url
      @path     = path
      @params = params
      @headers  = headers
      @body     = body
    end

    #: (untyped value) -> void
    def path=(value)
      @path = Helper::Params.validate_and_normalize_path(value)
    end

    #: (untyped value) -> void
    def params=(value)
      @path = Helper::Params.validate_and_normalize_path(value)
    end

    #: (untyped value) -> void
    def headers=(value)
      @headers = Helper::Params.validate_and_normalize_headers(value)
    end

    #: (untyped? value) -> void
    def body=(value)
      @body = Helper::Params.validate_and_normalize_body(value)
    end

    #: -> String
    def url
      @base_url + @path
    end
  end
end
