# frozen_string_literal: true

require 'test_helper'

module Alice
  class ResponseTest < Minitest::Test

    def test_response_exposes_status
      response = FactoryBot.build(:response, status: 200)

      assert_equal 200, response.status
    end
  end
end
