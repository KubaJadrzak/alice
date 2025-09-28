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

    #: Error?
    attr_reader :error

    #: (status: Integer, headers: Hash[String, String], body: String?, error: Error?) -> void
    def initialize(status:, headers:, body:, error:)
      @status  = status.to_i #: Integer
      @headers = headers #: Hash[String, String]
      @body    = body #: String?
      @error   = error #: Error?
    end

    #: -> bool
    def success?
      @error.nil? && (200..299).include?(@status)
    end

    #: -> bool
    def failure?
      !success?
    end

    #: -> bool
    def timeout?
      @error.is_a?(Alice::Errors::TimeoutError)
    end

    #: -> bool
    def connection_failed?
      @error.is_a?(Alice::Errors::ConnectionFailed)
    end

    #: -> bool
    def ssl_error?
      @error.is_a?(Alice::Errors::SSLError)
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
