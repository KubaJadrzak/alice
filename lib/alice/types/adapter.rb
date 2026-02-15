# typed: strict
# frozen_string_literal: true

module Alice
  module Types
    class Adapter

      #: singleton(Alice::Adapter::Base)
      attr_reader :klass

      #: (?untyped adapter) -> void
      def initialize(adapter = :net_http)
        name, klass = validate_and_set(adapter)

        @name  = T.let(name, Symbol)
        @klass = T.let(klass, T.class_of(Alice::Adapter::Base))
      end

      #: -> Symbol
      def to_sym
        @name
      end

      private

      #: (untyped) -> [Symbol, singleton(Alice::Adapter::Base)]
      def validate_and_set(adapter)
        case adapter&.to_sym
        when :net_http
          [:net_http, Alice::Adapter::NetHTTP]
        else
          Kernel.raise Alice::Error::ArgumentError, "unknown adapter #{adapter}"
        end
      end
    end
  end
end
