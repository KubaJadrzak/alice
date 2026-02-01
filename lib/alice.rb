# typed: strict
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

require_relative 'alice/version'
require_relative 'alice/request'
require_relative 'alice/response'
require_relative 'alice/adapter'
require_relative 'alice/client'
require_relative 'alice/error'

module Alice
  class << self
    #: (base_url: untyped, ?adapter: singleton(Alice::Adapter::Base)?) -> Alice::Client
    def new(base_url:, adapter: nil)
      raise ArgumentError, 'base_url must be a String' unless base_url.is_a?(String)

      adapter = set_adapter(adapter)
      Client.new(base_url: base_url, adapter: adapter)
    end

    private

    #: (singleton(Alice::Adapter::Base)?) -> singleton(Alice::Adapter::Base)
    def set_adapter(adapter)
      return Adapter::NetHTTP unless adapter

      case adapter
      when :net_http
        Adapter::NetHTTP
      else
        raise ArgumentError, "unknown adapter #{adapter}"
      end
    end
  end
end
