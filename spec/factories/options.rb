FactoryBot.define do
  factory :option do
    content { "Alpha" }
    correct { false }
    association :question
  end
end
