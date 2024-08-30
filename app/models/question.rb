# frozen_string_literal: true

# Question Model
class Question < ApplicationRecord
  belongs_to :assessment
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  # Validation
  validates :content, presence: true
  validate :only_one_correct_option

  private

  def only_one_correct_option
    return unless options.reject(&:marked_for_destruction?).select(&:correct).size > 1

    errors.add(:base, 'There can only be one correct option per question')
  end
end
