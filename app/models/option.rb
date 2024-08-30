# frozen_string_literal: true

# Option Model
class Option < ApplicationRecord
  belongs_to :question
  validates :content, presence: true
  validates :correct, inclusion: { in: [true, false] }
end
