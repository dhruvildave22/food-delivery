# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    role { %w[admin manager customer delivery_agent customer_support].sample }
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    password { Faker::Alphanumeric.alpha(number: 8) }
  end
end
