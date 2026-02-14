# typed: strict
# frozen_string_literal: true

module Alice
  module Adapter
    # @abstract
    class Base
      class << self
        extend T::Sig
        extend T::Helpers
        abstract!

        sig { abstract.params(request: Alice::Request).returns(Alice::Response) }
        def call(request); end
      end
    end
  end
end

require_relative 'adapter/net_http'
