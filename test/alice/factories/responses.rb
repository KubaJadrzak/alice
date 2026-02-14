FactoryBot.define do
  factory :response, class: 'Alice::Response' do
    status   { 200 }
    headers  { { 'Content-Type' => 'application/json' } }
    raw_body { '{"message":"ok"}' }
    association :request

    initialize_with do
      new(
        status:   status,
        headers:  headers,
        raw_body: raw_body,
        request:  request,
      )
    end

    trait :success do
      status { 200 }
    end

    trait :created do
      status { 201 }
    end

    trait :no_content do
      status { 204 }
      raw_body { nil }
    end

    trait :client_error do
      status { 400 }
      raw_body { '{"error":"bad_request"}' }
    end

    trait :unauthorized do
      status { 401 }
      raw_body { '{"error":"unauthorized"}' }
    end

    trait :not_found do
      status { 404 }
      raw_body { '{"error":"not_found"}' }
    end

    trait :server_error do
      status { 500 }
      raw_body { '{"error":"internal_server_error"}' }
    end

    trait :json_body do
      raw_body { '{"data":{"id":1,"name":"Alice"}}' }
      headers  { { 'Content-Type' => 'application/json' } }
    end

    trait :invalid_json do
      raw_body { 'not valid json {' }
      headers  { { 'Content-Type' => 'application/json' } }
    end

    trait :empty_body do
      raw_body { nil }
    end
  end
end
