# frozen_string_literal: true

# Assessment Policy
class AssessmentPolicy < ApplicationPolicy
  def attempt?
    user_assigned_to_assessment?
  end

  private

  def user_assigned_to_assessment?
    record.users.include?(user) # Example logic if `users` is an association on `Assessment`
  end
end
