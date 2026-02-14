# typed: strict
# frozen_string_literal: true

module Alice
  class Response

    #: Integer
    attr_reader :status

    #: Hash[String, String]
    attr_reader :headers

    #: String?
    attr_reader :raw_body

    #: Alice::Request
    attr_reader :request

    #: (status: Integer, headers: Hash[String, String], raw_body: String?, request: Alice::Request) -> void
    def initialize(status:, headers:, raw_body:, request:)
      @status  = status
      @headers = headers
      @raw_body = raw_body
      @request = request
    end

    #: -> bool
    def success?
      (200..299).include?(@status)
    end

    #: -> bool
    def failure?
      !success?
    end

    #: -> JSONValue?
    def body
      body = raw_body
      return unless body

      JSON.parse(body)
    rescue JSON::ParserError
      raise Alice::Error::InvalidJSON
    end

    #: -> bool
    def client_error?
      (400..499).include?(@status)
    end

    #: -> bool
    def server_error?
      (500..599).include?(@status)
    end
  end
end
