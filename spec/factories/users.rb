# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "foo#{n}" }
    email { "#{username}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  trait :admin do
    role { 'admin' }
  end

  trait :regular do
    role { 'user' }
  end
end
