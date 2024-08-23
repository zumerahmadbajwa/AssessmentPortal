class Result < ApplicationRecord
  belongs_to :user
  belongs_to :assessment
  has_many :user_answers, dependent: :destroy

  validates :user, :assessment, presence: true
end
