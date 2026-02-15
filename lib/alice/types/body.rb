# typed: strict
# frozen_string_literal: true

module Alice
  module Types
    class Body

      #:  Hash[String, untyped]
      attr_reader :body

      #: (?untyped? body) -> void
      def initialize(body = nil)
        @body = validate_and_normalize(body) #:  Hash[String, untyped]
      end

      #: -> Hash[String, untyped]
      def to_h
        @body.dup
      end

      private

      #: (untyped? body) -> Hash[String, untyped]
      def validate_and_normalize(body)
        return {} unless body

        Kernel.raise Alice::Error::ArgumentError, 'body must be a Hash' unless body.is_a?(Hash)
        body.each_with_object({}) do |(key, value), acc|
          next if value.nil?

          acc[key.to_s] =
            case value
            when Hash
              validate_and_normalize(value)
            when Array
              validate_and_normalize_array(value)
            else
              value
            end
        end
      end

      #: (Array[untyped]) -> Array[untyped]
      def validate_and_normalize_array(array)
        array.each_with_object([]) do |value, acc|
          next if value.nil?

          acc << case value
                 when Hash
                   validate_and_normalize(value)
                 when Array
                   validate_and_normalize_array(value)
                 else
                   value
                 end
        end
      end
    end
  end
end
