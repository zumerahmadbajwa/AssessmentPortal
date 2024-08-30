# frozen_string_literal: true

# User Policy
class UserPolicy < ApplicationPolicy
  # UserPolicy::Scope
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.email.match?('admin@example.com')
  end
end
