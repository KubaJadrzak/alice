# typed: strict
# frozen_string_literal: true

module Alice
  module Adapter
    # @abstract
    class Base
      class << self
        #: (Alice::Request request) -> Alice::Response
        def call(request)
          raise NotImplementedError, 'Adapters must implement #call'
        end
      end
    end
  end
end

require_relative 'adapter/net_http'
