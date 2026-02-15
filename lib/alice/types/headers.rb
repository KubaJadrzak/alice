# typed: strict
# frozen_string_literal: true

module Alice
  module Types
    class Headers
      extend T::Sig

      #: (?untyped headers) -> void
      def initialize(headers = {})
        defaults = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
        headers = validate_and_normalize(headers)
        @headers = defaults.merge(headers) #: Hash[String, String]
      end

      #: (untyped key) -> void
      def [](key)
        @headers[key.to_s]
      end

      #: (untyped key, untyped value) -> void
      def []=(key, value)
        @headers[key.to_s] = value.to_s
      end

      #: -> Hash[String, String]
      def to_h
        @headers.dup
      end

      private


      #: (untyped) -> Hash[String, String]
      def validate_and_normalize(headers)
        Kernel.raise Alice::Error::ArgumentError, 'headers must be a Hash' unless headers.is_a?(Hash)
        normalized = {}

        headers.each do |key, value|
          next if value.nil?

          if value.is_a?(Hash) || value.is_a?(Array)
            Kernel.raise Alice::Error::ArgumentError, "invalid header value for #{key}"
          end

          normalized[key.to_s] = value.to_s
        end

        normalized
      end
    end
  end
end
