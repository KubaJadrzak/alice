# typed: strict
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

require_relative 'alice/version'
require_relative 'alice/request'
require_relative 'alice/response'
require_relative 'alice/adapter'
require_relative 'alice/adapters/net_http'
require_relative 'alice/client'
require_relative 'alice/errors'

module Alice

  #: (url: String) -> Alice::Client
  def new(url:)
    Client.new(base_url: url)
  end

end
