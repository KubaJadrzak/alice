# typed: strict
# frozen_string_literal: true

module Alice
  module Helper
    module Params
      extend self

      #: (untyped) -> String
      def validate_and_normalize_base_url(base_url)
        Kernel.raise ArgumentError, 'base_url must be a String' unless base_url.is_a?(String)

        normalized = base_url.chomp('/')
        return normalized if normalized.start_with?('http://', 'https://')

        "https://#{normalized}"
      end

      #: (untyped) -> singleton(Alice::Adapter::Base)
      def validate_and_set_adapter(adapter)
        return Adapter::NetHTTP unless adapter

        case adapter
        when :net_http
          Adapter::NetHTTP
        else
          Kernel.raise ArgumentError, "unknown adapter #{adapter}"
        end
      end

      #: (untyped) -> String
      def validate_and_normalize_path(path)
        Kernel.raise ArgumentError, 'path must be a String' unless path.nil? || path.is_a?(String)

        return '/' if path.nil? || path.empty?

        path.start_with?('/') ? path : "/#{path}"
      end

      #: (untyped) -> Hash[String, String]
      def validate_and_normalize_headers(headers)
        Kernel.raise ArgumentError, 'headers must be a Hash' unless headers.is_a?(Hash)
        normalized = {}

        headers.each do |key, value|
          next if value.nil?

          if value.is_a?(Hash) || value.is_a?(Array)
            Kernel.raise ArgumentError, "invalid header value for #{key}"
          end

          normalized[key.to_s] = value.to_s
        end

        normalized
      end

      #: (untyped? body) -> Hash[String, untyped]
      def validate_and_normalize_body(body)
        return {} unless body

        Kernel.raise ArgumentError, 'body must be a Hash' unless body.is_a?(Hash)
        body.each_with_object({}) do |(key, value), acc|
          next if value.nil?

          acc[key.to_s] =
            case value
            when Hash
              validate_and_normalize_body(value)
            when Array
              validate_and_normalize_array(value)
            else
              value.to_s
            end
        end
      end

      #: (Array[untyped]) -> Array[untyped]
      def validate_and_normalize_array(array)
        array.each_with_object([]) do |value, acc|
          next if value.nil?  # <-- drop nils

          acc << case value
                 when Hash
                   validate_and_normalize_body(value)
                 when Array
                   validate_and_normalize_array(value)
                 else
                   value.to_s
                 end
        end
      end
    end
  end
end
