# frozen_string_literal: true

require 'test_helper'

module Alice
  class ClientTest < Minitest::Test
    def test_exposes_base_url
      client = Alice.new(base_url: 'https://example.com/')

      assert_instance_of Alice::Client, client

      assert_equal 'https://example.com/', client.base_url
    end

    def test_exposes_adapter
      client = Alice.new(base_url: 'https://example.com/')

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
      data = JSON.parse(response.body)
      assert_equal 'https://httpbin.org/get', data['url']
    end
  end
end
