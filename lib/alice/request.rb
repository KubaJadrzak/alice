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

    #: Hash[Symbol,String]?
    attr_reader :body

    #: (method: Symbol, base_url: String, path: String, headers: Hash[String, String], body: Hash[Symbol,String]?) -> void
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
      raise ArgumentError, 'path must be a String' unless value.is_a?(String)

      @path = value
    end

    #: (untyped value) -> void
    def headers=(value)
      unless value.is_a?(Hash) && value.keys.all? { |k| k.is_a?(String) } && value.values.all? { |v| v.is_a?(String) }
        raise ArgumentError, 'headers must be a Hash with String keys and String values'
      end

      @headers = value
    end

    #: (untyped? value) -> void
    def body=(value)
      unless value.is_a?(Hash) && value.keys.all? { |k| k.is_a?(Symbol) } && value.values.all? { |v| v.is_a?(String) }
        raise ArgumentError, 'body must be nil or a Hash with Symbol keys and String values'
      end


      @body = value
    end

    #: -> String
    def url
      @base_url + @path
    end
  end
end
