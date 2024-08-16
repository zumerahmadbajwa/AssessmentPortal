class Question < ApplicationRecord
  belongs_to :assessment
  has_many :options, dependent: :destroy
  validates :content, presence: true
  validate :validate_option_count
  accepts_nested_attributes_for :options, allow_destroy: true

  private

  def validate_option_count
    errors.add(:base, "A question must have exactly 4 options") if options.size != 4
  end
end
