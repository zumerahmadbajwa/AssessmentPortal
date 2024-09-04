# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    content { 'New Question' }
    association :assessment
  end
end
