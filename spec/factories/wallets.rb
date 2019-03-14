FactoryBot.define do
  factory :wallet do
    account { 100000 }
    association :user
  end
end
