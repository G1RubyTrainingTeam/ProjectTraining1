FactoryBot.define do
  factory :user do
    name { "Hanh" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "123456" }
    role { nil }
    provider { nil }
    avatar { nil }
  end
end
