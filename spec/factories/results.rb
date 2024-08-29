FactoryBot.define do
  factory :result do
    score { '10' }
    user_answers { [] } # Modify this according to how user_answers are structured in model
    assessment # Associates the result with an assessment
    user # Associates the result with a user (assuming a result belongs to a user)
  end
end
