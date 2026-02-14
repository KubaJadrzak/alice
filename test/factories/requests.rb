# frozen_string_literal: true

FactoryBot.define do
  factory :request, class: 'Alice::Request' do
    http_method   { :get }
    base_url { 'https://api.example.com' }
    path     { '/resource' }
    headers  { { 'Accept' => 'application/json' } }
    body     { nil }

    trait :get do
      http_method { :get }
    end

    trait :delete do
      http_method { :delete }
    end

    trait :post do
      http_method { :post }
      body   { { 'name' => 'Alice' } }
      headers { super().merge('Content-Type' => 'application/json') }
    end

    trait :put do
      http_method { :put }
      body   { { 'name' => 'Updated Alice' } }
      headers { super().merge('Content-Type' => 'application/json') }
    end

    trait :patch do
      http_method { :patch }
      body   { { 'name' => 'Patched Alice' } }
      headers { super().merge('Content-Type' => 'application/json') }
    end

    initialize_with do
      new(
        http_method: http_method,
        base_url:    base_url,
        path:        path,
        headers:     headers,
        body:        body,
      )
    end
  end
end
