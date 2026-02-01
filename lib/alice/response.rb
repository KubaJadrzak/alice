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

    #: Error::Base?
    attr_reader :errors

    #: (status: Integer, headers: Hash[String, String], body: String?, errors: Error::Base?) -> void
    def initialize(status:, headers:, body:, errors:)
      @status  = status.to_i #: Integer
      @headers = headers #: Hash[String, String]
      @body    = body #: String?
      @errors  = errors #: Error::Base?
    end

    #: -> bool
    def success?
      @errors.nil? && (200..299).include?(@status)
    end

    #: -> bool
    def failure?
      !success?
    end

    #: -> bool
    def timeout?
      @errors.is_a?(Alice::Error::TimeoutError)
    end

    #: -> bool
    def connection_failed?
      @errors.is_a?(Alice::Error::ConnectionFailed)
    end

    #: -> bool
    def ssl_error?
      @errors.is_a?(Alice::Error::SSLError)
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
