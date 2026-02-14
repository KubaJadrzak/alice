# typed: strict
# frozen_string_literal: true

module Alice
  module Error
    class Base < StandardError; end
  end
end

require_relative 'error/connection_failed'
require_relative 'error/ssl_error'
require_relative 'error/timeout_error'
require_relative 'error/invalid_json'
