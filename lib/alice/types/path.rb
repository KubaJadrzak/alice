# typed: strict
# frozen_string_literal: true

module Alice
  module Types
    class Path

      #: (?untyped path) -> void
      def initialize(path = '/')
        @path = validate_and_normalize(path).freeze #: String
      end

      #: -> String
      def to_s
        @path
      end

      private

      #: (untyped) -> String
      def validate_and_normalize(path)
        Kernel.raise Alice::Error::ArgumentError, 'path must be a String' unless path.is_a?(String)

        path.start_with?('/') ? path : "/#{path}"
      end
    end
  end
end
