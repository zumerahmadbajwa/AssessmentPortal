FactoryBot.define do
  factory :user do
    username { "Charlie" }
    email { "charlie@example.com" }
    password { "password123" }
    password_confirmation { 'password123' }
  end

  trait :admin do
    role { "admin" }
  end

  trait :regular do
    role { "user" }
  end
end
