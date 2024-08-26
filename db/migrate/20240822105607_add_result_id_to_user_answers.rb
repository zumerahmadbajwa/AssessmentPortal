# frozen_string_literal: true

# AddResultIdToUSerAnswers
class AddResultIdToUserAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :user_answers, :result_id, :integer
  end
end
