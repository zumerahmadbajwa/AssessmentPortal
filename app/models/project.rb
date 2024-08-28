# frozen_string_literal: true

# Project Model
class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :assessments, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
end
