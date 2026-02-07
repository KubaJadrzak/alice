# frozen_string_literal: true

require 'test_helper'

class AliceTest < Minitest::Test
  def test_have_version_number
    refute_nil ::Alice::VERSION
  end

  def test_return_alice_client
    client = Alice.new(base_url: 'https://example.com')

    assert_instance_of Alice::Client, client
    assert_equal 'https://example.com', client.base_url
  end

  def test_raise_argument_error_when_base_url_is_not_a_string
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: 1)
    end

    assert_equal 'base_url must be a String', error.message
  end

  def test_raise_argument_error_when_base_url_is_missing
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: nil)
    end

    assert_equal 'base_url must be a String', error.message
  end

  def test_normalize_base_url_by_removing_trailing_slash
    client = Alice.new(base_url: 'https://example.com/')

    assert_equal 'https://example.com', client.base_url
  end

  def test_normalize_base_url_by_adding_https_if_missing
    client = Alice.new(base_url: 'example.com')
    client2 = Alice.new(base_url: 'https://example.com')
    client3 = Alice.new(base_url: 'http://example.com')

    assert_equal 'https://example.com', client.base_url
    assert_equal 'https://example.com', client2.base_url
    assert_equal 'http://example.com', client3.base_url
  end

  def test_raise_argument_error_when_adapter_is_unknown
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: 'https://example.com/', adapter: :fake_adapter)
    end

    assert_equal 'unknown adapter fake_adapter', error.message
  end

  def test_set_net_http_as_default_adapter
    client = Alice.new(base_url: 'https://example.com')

    assert_equal Alice::Adapter::NetHTTP, client.adapter
  end
end
