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

    #: (status: Integer, headers: Hash[String, String], body: String?) -> void
    def initialize(status:, headers:, body:)
      @status  = status #: Integer
      @headers = headers #: Hash[String, String]
      @body    = body #: String?

    end

    #: -> bool
    def success?
      (200..299).include?(@status)
    end

    #: -> bool
    def failure?
      !success?
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
