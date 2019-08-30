# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { Faker::Name.name }
    area { Faker::Address.street_name }
    address { Faker::Address.full_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    rating { Faker::Number.between(from: 1, to: 5) }
    average_delivery_time { Faker::Number.number(digits: 2) }
    average_cost_per_two { Faker::Number.number(digits: 3) }
  end
end
