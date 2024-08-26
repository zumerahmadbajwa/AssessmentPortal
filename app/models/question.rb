class Question < ApplicationRecord
  belongs_to :assessment
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
  
  
  validates :content, presence: true
  validate :only_one_correct_option

  private

  def only_one_correct_option
    if options.reject(&:marked_for_destruction?).select(&:correct).size > 1
      errors.add(:base, "Only one option can be marked as correct")
    end
  end
end
