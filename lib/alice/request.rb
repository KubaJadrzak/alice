# typed: strict
# frozen_string_literal: true

module Alice
  class Request

    #: String
    attr_reader :method

    #: String
    attr_reader :base_url

    #: String
    attr_reader :path

    #: Hash[String, String]
    attr_reader :headers

    #: String?
    attr_reader :body

    #: (method: Symbol, base_url: String, path: String, ?headers: Hash[String, String], ?body: String?) -> void
    def initialize(method:, base_url:, path:, headers: {}, body: nil)
      @method   = method.to_s.downcase #: String
      @base_url = base_url #: String
      @path     = path #: String
      @headers  = headers #: Hash[untyped, untyped]
      @body     = body #: untyped
    end

    #: -> String
    def url
      URI.join(@base_url, @path).to_s
    end
  end
end
