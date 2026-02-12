# frozen_string_literal: true

require 'test_helper'

module Alice
  class RequestTest < Minitest::Test
    def setup
      @req = Request.new(
        http_method: :post,
        base_url:    'https://example.com',
        path:        '/',
        headers:     {},
        body:        nil,
      )
    end

    def test_apply_configuration_via_block
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      block.call(@req)

      assert_equal '/api/v1/users', @req.path

      expected_headers = {
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json',
      }
      assert_equal expected_headers, @req.headers

      expected_body = {
        'name' => 'Alice',
        'role' => 'admin',
      }
      assert_equal expected_body, @req.body
    end

    def test_raise_argument_error_when_path_is_not_a_string
      error = assert_raises(ArgumentError) { @req.path = 123 }

      assert_equal 'path must be a String', error.message
    end

    def test_normalize_path_by_adding_leading_slash
      block = proc do |r|
        r.path = 'api/v1/users'
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      block.call(@req)

      assert_equal '/api/v1/users', @req.path
    end

    def test_normalize_path_by_not_adding_leading_slash_if_present
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      block.call(@req)

      assert_equal '/api/v1/users', @req.path
    end

    def test_normalize_path_by_returning_slash_if_path_not_provided
      block = proc do |r|
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      block.call(@req)

      assert_equal '/', @req.path
    end

    def test_raise_argument_error_when_path_is_not_string
      block = proc do |r|
        r.path = 123
        r.headers = {
          'Content-Type' => 'application/json',
          'Accept'       => 'application/json',
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      error = assert_raises(ArgumentError) do
        block.call(@req)
      end
      assert_equal 'path must be a String', error.message
    end

    def test_normalize_headers_by_converting_all_values_to_strings
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'Content-Type' => 123,
          123            => :symbol,
        }
        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      block.call(@req)

      expected = {
        'Content-Type' => '123',
        '123'          => 'symbol',
      }
      assert_equal expected, @req.headers
    end

    def test_raise_argument_error_if_headers_are_not_hash
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = 123

        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      error = assert_raises(ArgumentError) do
        block.call(@req)
      end

      assert_equal 'headers must be a Hash', error.message
    end

    def test_raise_argument_error_if_headers_hash_values_are_hashes
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'key' => {
            'nested_key' => 'nested_valued',
          },
        }

        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      error = assert_raises(ArgumentError) do
        block.call(@req)
      end

      assert_equal 'invalid header value for key', error.message
    end

    def test_raise_argument_error_if_headers_hash_values_are_arrays
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {
          'key' => %w[value1 value2 value3],
        }

        r.body = { 'name' => 'Alice', 'role' => 'admin' }
      end

      error = assert_raises(ArgumentError) do
        block.call(@req)
      end

      assert_equal 'invalid header value for key', error.message
    end

    def test_normalize_body_by_converting_all_values_to_strings
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = { 'Accept' => 'application/json' }
        r.body = {
          123     => :alice,
          'role'  => 'admin',
          :active => true,
        }
      end

      block.call(@req)

      expected = {
        '123'    => 'alice',
        'role'   => 'admin',
        'active' => 'true',
      }

      assert_equal expected, @req.body
    end

    def test_normalize_body_with_nested_hash
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {}
        r.body = {
          user: {
            id:   1,
            name: :alice,
          },
        }
      end

      block.call(@req)

      expected = {
        'user' => {
          'id'   => '1',
          'name' => 'alice',
        },
      }

      assert_equal expected, @req.body
    end

    def test_normalize_body_with_array_values
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {}
        r.body = {
          roles: [:admin, :user, 123],
        }
      end

      block.call(@req)

      expected = {
        'roles' => %w[admin user 123],
      }

      assert_equal expected, @req.body
    end

    def test_normalize_body_with_nested_arrays_and_hashes
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {}
        r.body = {
          user: {
            id:    1,
            flags: [
              { name: :beta, enabled: true },
              { name: :dark_mode, enabled: false },
            ],
          },
        }
      end

      block.call(@req)

      expected = {
        'user' => {
          'id'    => '1',
          'flags' => [
            { 'name' => 'beta',      'enabled' => 'true'  },
            { 'name' => 'dark_mode', 'enabled' => 'false' },
          ],
        },
      }

      assert_equal expected, @req.body
    end

    def test_normalize_body_drops_nil_values
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {}
        r.body = {
          name: 'Alice',
          age:  nil,
          meta: {
            active: true,
            notes:  nil,
          },
        }
      end

      block.call(@req)

      expected = {
        'name' => 'Alice',
        'meta' => {
          'active' => 'true',
        },
      }

      assert_equal expected, @req.body
    end

    def test_normalize_body_drops_nil_value_inside_arrays
      block = proc do |r|
        r.path = '/api/v1/users'
        r.headers = {}
        r.body = {
          tags: ['a', nil, :b],
        }
      end

      block.call(@req)

      expected = {
        'tags' => %w[a b],
      }

      assert_equal expected, @req.body
    end

    def test_url_return_base_url_plus_path
      @req.path = '/foo'
      assert_equal 'https://example.com/foo', @req.url
    end
  end
end
