# typed: strict
# frozen_string_literal: true

module Alice
  module Errors
    class Base < StandardError; end
  end
end

require_relative 'errors/connection_failed'
require_relative 'errors/ssl_error'
require_relative 'errors/timeout_error'
