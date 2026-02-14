# frozen_string_literal: true

require 'test_helper'

module Alice
  class ResponseTest < Minitest::Test

    def test_response_exposes_status
      response = FactoryBot.build(:response)

      assert_equal true, response.success?
      assert_equal false, response.failure?
      assert_equal 200, response.status
    end

    def test_response_exposes_headers_as_hash
      response = FactoryBot.build(:response)
      headers = response.headers

      assert_equal true, response.success?
      assert_equal false, response.failure?
      assert_equal headers['Content-Type'], 'application/json'
    end

    def test_response_exposes_body_as_json
      response = FactoryBot.build(:response, :json_body)
      body = response.body

      assert_equal true, response.success?
      assert_equal false, response.failure?
      assert_equal body.dig('data', 'id'), 1
      assert_equal body.dig('data', 'name'), 'Alice'
    end

    def test_response_exposes_raw_body_as_string
      response = FactoryBot.build(:response)
      raw_body = response.raw_body

      assert_equal true, response.success?
      assert_equal false, response.failure?
      assert_equal raw_body, '{"message":"ok"}'
    end

    def test_response_exposes_client_error
      response = FactoryBot.build(:response, :client_error)
      body = response.body

      assert_equal false, response.success?
      assert_equal true, response.failure?
      assert_equal true, response.client_error?
      assert_equal body['error'], 'bad_request'
    end

    def test_response_exposes_server_error
      response = FactoryBot.build(:response, :server_error)
      body = response.body

      assert_equal false, response.success?
      assert_equal true, response.failure?
      assert_equal true, response.server_error?
      assert_equal body['error'], 'internal_server_error'
    end

    def test_response_raises_when_invalid_json
      response = FactoryBot.build(:response, :invalid_json)
      assert_equal true, response.success?
      assert_equal false, response.failure?
      assert_equal 'not valid json {', response.raw_body

      assert_raises(Alice::Error::InvalidJSON) do
        response.body
      end
    end
  end
end
