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
  end
end
