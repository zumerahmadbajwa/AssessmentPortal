# frozen_string_literal: true

# Assessment Model
class Assessment < ApplicationRecord
  belongs_to :project
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :user_assessments
  has_many :users, through: :user_assessments
  has_many :results
end
