# typed: strict
# frozen_string_literal: true

require_relative 'errors/connection_failed'
require_relative 'errors/ssl_error'
require_relative 'errors/timeout_error'

module Alice
  class Error < StandardError; end
end
