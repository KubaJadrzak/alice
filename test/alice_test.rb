# frozen_string_literal: true

require 'test_helper'

class AliceTest < Minitest::Test
  def test_have_version_number
    refute_nil ::Alice::VERSION
  end

  def test_returns_alice_client
    client = Alice.new(base_url: 'https://example.com/')

    assert_instance_of Alice::Client, client
  end

  def test_raises_argument_error_when_base_url_is_not_a_string
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: 1)
    end

    assert_equal 'base_url must be a String', error.message
  end

  def test_raises_argument_error_when_base_url_is_missing
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: nil)
    end

    assert_equal 'base_url must be a String', error.message
  end

  def test_raises_argument_error_when_adapter_is_unknown
    error = assert_raises(ArgumentError) do
      Alice.new(base_url: 'https://example.com/', adapter: :fake_adapter)
    end

    assert_equal 'unknown adapter fake_adapter', error.message
  end
end
