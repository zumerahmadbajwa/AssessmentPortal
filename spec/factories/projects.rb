# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Sample Project' }
    description { 'This is a description of the sample project.' }
    start_date { 1.day.ago }
    end_date { 1.day.from_now }
    status { 'active' }
  end
end
