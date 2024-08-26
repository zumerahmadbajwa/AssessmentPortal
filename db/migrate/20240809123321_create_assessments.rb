# frozen_string_literal: true

# Create Assessments
class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.string :title
      t.text :description
      t.references :project

      t.timestamps
    end
  end
end
