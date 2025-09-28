# typed: strict
# frozen_string_literal: true

module Alice
  class Client
    ALLOWED_METHODS = %i[get post put patch delete head options].freeze

    #: String
    attr_reader :base_url

    #: Hash[untyped, untyped]
    attr_reader :headers

    #: Adapter
    attr_reader :adapter

    #: (base_url: untyped, ?headers: untyped, ?adapter: untyped) -> void
    def initialize(base_url:, headers: {}, adapter: Adapters::NetHTTP.new)
      raise ArgumentError, 'base_url must be a String' unless base_url.is_a?(String)
      raise ArgumentError, 'headers must be a Hash' unless headers.is_a?(Hash)
      raise ArgumentError, 'adapter must inherit from Adapters::Adapter' unless adapter.is_a?(Adapter)

      @base_url = base_url
      @headers  = headers
      @adapter  = adapter
    end

    #: (untyped, ?headers: untyped, ?body: untyped, ?json: untyped) -> void
    def get(path, headers: {}, body: nil, json: nil)
      request(:get, path, headers: headers, body: body, json: json)
    end

    #: (untyped, ?headers: untyped, ?body: untyped, ?json: untyped) -> void
    def post(path, headers: {}, body: nil, json: nil)
      request(:post, path, headers: headers, body: body, json: json)
    end

    private

    #: (untyped, untyped, ?headers: untyped, ?body: untyped, ?json: untyped) -> void
    def request(method, path, headers: {}, body: nil, json: nil)
      method = validate_method(method)
      path = validate_path(path)
      all_headers = normalize_headers(headers)
      payload = validate_body(body, json)

      req = Request.new(
        method:   method,
        base_url: @base_url,
        path:     path,
        headers:  all_headers,
        body:     payload,
      )

      @adapter.call(req)
    end

    #: (untyped) -> Symbol
    def validate_method(method)
      method_sym = method.to_sym
      unless ALLOWED_METHODS.include?(method_sym)
        raise ArgumentError, "invalid HTTP method: #{method.inspect}"
      end

      method_sym
    end

    #: (untyped) -> String
    def validate_path(path)
      unless path.is_a?(String)
        raise ArgumentError, "path must be a String, got #{path.class}"
      end

      path.start_with?('/') ? path : "/#{path}"
    end

    #: (untyped) -> Hash[String, String]
    def normalize_headers(headers)
      @headers.merge(headers.transform_keys(&:to_s).transform_values(&:to_s))
    end

    #: (untyped, untyped) -> String?
    def validate_body(body, json)
      if body && json
        raise ArgumentError, 'pass either :body or :json, not both'
      end
      if body && !body.is_a?(String)
        raise ArgumentError, "body must be a String, got #{body.class}"
      end

      json ? JSON.dump(json) : body
    end
  end
end
