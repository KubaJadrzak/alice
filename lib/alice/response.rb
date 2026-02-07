# typed: strict
# frozen_string_literal: true

module Alice
  class Response

    #: Integer
    attr_reader :status

    #: Hash[String, String]
    attr_reader :headers

    #: String?
    attr_reader :body

    #: Alice::Request
    attr_reader :request

    #: (status: Integer, headers: Hash[String, String], body: String?, request: Alice::Request) -> void
    def initialize(status:, headers:, body:, request:)
      @status  = status
      @headers = headers
      @body    = body
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
    def parsed_body
      raw_body = body
      return unless raw_body

      JSON.parse(raw_body)
    rescue JSON::ParserError
      nil
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
