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

    def test_get_applies_block_configuration_to_request
      client = Alice.new(base_url: 'https://example.com/')

      assert_instance_of Alice::Client, client

      client.send(:get) do |req|
        req.path = 'test_path'
        req.headers['Accept'] = 'test_header_1'
        req.headers['Authorization'] = 'test_header_2'
        req.body = {
          param1: 'test_param_1',
          param2: 'test_param_2',
        }
      end
    end
  end
end
