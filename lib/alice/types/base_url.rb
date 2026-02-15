# typed: strict
# frozen_string_literal: true

module Alice
  module Types
    class BaseUrl

      #: (untyped base_url) -> void
      def initialize(base_url)
        @base_url = validate_and_normalize(base_url).freeze #: String
      end

      #: -> String
      def to_s
        @base_url
      end

      private

      #: (untyped) -> String
      def validate_and_normalize(base_url)
        unless base_url.is_a?(String) && !base_url.strip.empty?
          raise Alice::Error::ArgumentError, 'base_url must be a non-empty String'
        end

        normalized = base_url.chomp('/')
        return normalized if normalized.start_with?('http://', 'https://')

        "https://#{normalized}"
      end
    end
  end
end
