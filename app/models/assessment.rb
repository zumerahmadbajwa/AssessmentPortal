class Assessment < ApplicationRecord
  belongs_to :project
  has_many :user_assessments
  has_many :users, through: :user_assessments
  has_many :results
end
