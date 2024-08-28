FactoryBot.define do
  factory :assessment do
    title { "Test Assessment" }
    description { "Test Description" }
    association :project
  end
end
