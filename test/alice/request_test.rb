# frozen_string_literal: true

require 'test_helper'

module Alice
  class RequestTest < Minitest::Test
    def setup
      @req = Request.new(
        method:   :post,
        base_url: 'https://example.com',
        path:     '/',
        headers:  {},
        body:     nil,
      )
    end

    def test_configuration_applied_via_block
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { name: 'Alice', role: 'admin' }
      end

      block.call(@req)

      assert_equal '/api/v1/users', @req.path

      expected_headers = {
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json',
      }
      assert_equal expected_headers, @req.headers

      expected_body = {
        name: 'Alice',
        role: 'admin',
      }
      assert_equal expected_body, @req.body
    end

    def test_invalid_path_raises
      error = assert_raises(ArgumentError) { @req.path = 123 }

      assert_equal 'path must be a String', error.message
    end

    def test_invalid_body_raises
      first_error = assert_raises(ArgumentError) { @req.body = { 'name' => 'Alice' } }
      second_error = assert_raises(ArgumentError) { @req.body = { name: 123 } }

      assert_equal 'body must be nil or a Hash with Symbol keys and String values', first_error.message
      assert_equal 'body must be nil or a Hash with Symbol keys and String values', second_error.message
    end

    def test_url_returns_base_url_plus_path
      @req.path = '/foo'
      assert_equal 'https://example.com/foo', @req.url
    end
  end
end
