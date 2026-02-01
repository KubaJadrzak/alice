# typed: strict
# frozen_string_literal: true

module Alice
  class Client

    #: String
    attr_reader :base_url

    #: singleton(Adapter::Base)
    attr_reader :adapter

    #: (base_url: String, adapter: singleton(Adapter::Base)) -> void
    def initialize(base_url:, adapter:)
      @base_url = base_url
      @adapter = adapter
    end

    #: ?{ (Request req) -> void } -> Response
    def get(&block)
      raise ArgumentError, 'configuration of the request must be provided via block' unless block

      request(:get, &block)
    end

    private

    #: (Symbol method) { ( Request req ) -> untyped } -> Response
    def request(method, &block)

      req = Request.new(
        method:   method,
        base_url: @base_url,
        path:     '/',
        headers:  {},
        body:     nil,
      )

      block.call(req)

      @adapter.call(req)
    end
  end
end
