# typed: strict
# frozen_string_literal: true

module Alice
  class Request

    #: Symbol
    attr_reader :method

    #: String
    attr_reader :base_url

    #: String
    attr_reader :path

    #: Hash[String, String]
    attr_reader :headers

    #: Hash[String, String]?
    attr_reader :body

    #: (method: Symbol, base_url: String, path: String, headers: Hash[String, String], body: Hash[String ,String]?) -> void
    def initialize(method:, base_url:, path:, headers:, body:)
      @method   = method
      @base_url = base_url
      @path     = path
      @headers  = headers
      @body     = body
    end

    # ====== CUSTOM SETTERS ======

    #: (untyped value) -> void
    def path=(value)
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
