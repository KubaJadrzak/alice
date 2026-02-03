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
require_relative 'alice/helper'

module Alice
  class << self
    #: (base_url: untyped, ?adapter: untyped) -> Alice::Client
    def new(base_url:, adapter: nil)
      base_url = Helper::Params.validate_and_normalize_base_url(base_url)
      adapter = Helper::Params.validate_and_set_adapter(adapter)
      Client.new(base_url: base_url, adapter: adapter)
    end
  end
end
