# typed: strict
# frozen_string_literal: true

module Alice
  # JSONValue represents any valid JSON data
  JSONValue = T.type_alias do
    T.any(
      String,
      Integer,
      Float,
      TrueClass,
      FalseClass,
      NilClass,
      T::Array[T.untyped],
      T::Hash[String, T.untyped],
    )
  end
end
