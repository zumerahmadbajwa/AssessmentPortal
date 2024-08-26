# frozen_string_literal: true

# Create UserAssessments
class CreateUserAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_assessments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
