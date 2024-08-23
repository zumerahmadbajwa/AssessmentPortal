class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :assessment
  belongs_to :question
  belongs_to :selected_option, class_name: 'Option'
  belongs_to :result

  validates :user, :assessment, :question, :selected_option, :result, presence: true
end