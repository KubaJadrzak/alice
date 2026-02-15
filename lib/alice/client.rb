# typed: strict
# frozen_string_literal: true

module Alice
  class Client

    #: (base_url: String, adapter: singleton(Adapter::Base)) -> void
    def initialize(base_url:, adapter:)
      @base_url = Alice::Types::BaseUrl.new(base_url) #: Alice::Types::BaseUrl
      @adapter = Alice::Types::Adapter.new(adapter) #: Alice::Types::Adapter
    end

    #: -> String
    def base_url
      @base_url.to_s
    end

    #: -> Symbol
    def adapter
      @adapter.to_sym
    end

    #: ?{ (Request req) -> void } -> Response
    def get(&block)
      raise Alice::Error::ArgumentError, 'configuration of the request must be provided via block' unless block

      request(:get, &block)
    end

    private

    #: (Symbol http_method) { ( Request req ) -> untyped } -> Response
    def request(http_method, &block)

      req = Request.new(
        http_method: http_method,
        base_url:    @base_url,
      )

      block.call(req)

      @adapter.klass.call(req)
    end
  end
end
