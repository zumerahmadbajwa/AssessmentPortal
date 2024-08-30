FactoryBot.define do
  factory :question do
    content { "New Question" }
    association :assessment
  end
end
