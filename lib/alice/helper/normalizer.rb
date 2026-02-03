# typed: strict
# frozen_string_literal: true

module Alice
  module Helper
    module Normalizer
      extend self

      #: (String) -> String
      def normalize_base_url(url)
        normalized = url.chomp('/')
        return normalized if normalized.start_with?('http://', 'https://')

        "https://#{normalized}"
      end

      #: (String?) -> String
      def normalize_path(path)
        return '/' if path.nil? || path.empty?

        path.start_with?('/') ? path : "/#{path}"
      end

      #: (Hash[untyped, untyped]) -> Hash[String, String]
      def normalize_headers(headers)
        normalized = {}

        headers.each do |key, value|
          next if value.nil?

          if value.is_a?(Hash) || value.is_a?(Array)
            Kernel.raise ArgumentError, "invalid header value for #{key.inspect}"
          end

          normalized[key.to_s] = value.to_s
        end

        normalized
      end

      #: (untyped? body) -> Hash[String, untyped]
      def normalize_body(body)
        return {} unless body

        Kernel.raise ArgumentError, 'body must be a Hash' unless body.is_a?(Hash)
        body.each_with_object({}) do |(key, value), acc|
          next if value.nil?

          acc[key.to_s] =
            case value
            when Hash
              normalize_body(value)
            when Array
              normalize_array(value)
            else
              value.to_s
            end
        end
      end

      #: (Array[untyped]) -> Array[untyped]
      def normalize_array(array)
        array.map do |value|
          case value
          when Hash
            normalize_body(value)
          when Array
            normalize_array(value)
          else
            value.to_s
          end
        end
      end
    end
  end
end
