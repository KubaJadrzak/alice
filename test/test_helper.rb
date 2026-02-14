# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'alice'

require 'minitest/autorun'

require 'factory_bot'

FactoryBot.definition_file_paths = [File.expand_path('alice/factories', __dir__)]
FactoryBot.find_definitions
