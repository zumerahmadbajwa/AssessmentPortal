# frozen_string_literal: true

# Create Questions
class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :assessment, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
