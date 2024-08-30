# frozen_string_literal: true

# UserAssessment Model
class UserAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :assessment
end
