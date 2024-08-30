# frozen_string_literal: true

# ProjectUser Model
class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project

  # Validations
  validates :user_id, presence: true
  validates :project_id, presence: true
end
