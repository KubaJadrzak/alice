# frozen_string_literal: true

require 'test_helper'

module Alice
  class ClientTest < Minitest::Test
    def test_exposes_base_url
      client = Alice.new(base_url: 'https://example.com')

      assert_instance_of Alice::Client, client

      assert_equal 'https://example.com', client.base_url
    end

    def test_exposes_adapter
      client = Alice.new(base_url: 'https://example.com')

      assert_instance_of Alice::Client, client

      assert_equal Alice::Adapter::NetHTTP, client.adapter
    end

    def test_performs_request_and_returns_response
      client = Alice.new(base_url: 'https://httpbin.org')

      response = client.send(:get) do |req|
        req.path = '/get'
        req.headers['Accept'] = 'application/json'
      end

      assert_equal 200, response.status
      response_body = response.body
      response_headers = response.headers

      assert_equal true, response.success?
      assert_equal 200, response.status
      assert_equal 'https://httpbin.org/get', response_body['url']
      assert_equal 'application/json', response_headers['content-type']
    end

    def test_raise_argument_error_if_missing_configuration
      client = Alice.new(base_url: 'https://httpbin.org')

      error = assert_raises(Alice::Error::ArgumentError) do
        client.send(:get)
      end

      assert_equal 'configuration of the request must be provided via block', error.message
    end
  end
end
