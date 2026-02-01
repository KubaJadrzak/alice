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
      assert_equal({
                     'Content-Type' => 'application/json',
                     'Accept'       => 'application/json',
                   }, @req.headers,)
      assert_equal({ name: 'Alice', role: 'admin' }, @req.body)
    end

    def test_invalid_path_raises
      assert_raises(ArgumentError) { @req.path = 123 }
    end

    def test_invalid_headers_raises
      assert_raises(ArgumentError) { @req.headers = { symbol_key: 'value' } }
      assert_raises(ArgumentError) { @req.headers = { 'Key' => 123 } }
    end

    def test_invalid_body_raises
      assert_raises(ArgumentError) { @req.body = { 'name' => 'Alice' } }
      assert_raises(ArgumentError) { @req.body = { name: 123 } }
    end

    def test_url_returns_base_url_plus_path
      @req.path = '/foo'
      assert_equal 'https://example.com/foo', @req.url
    end
  end
end
