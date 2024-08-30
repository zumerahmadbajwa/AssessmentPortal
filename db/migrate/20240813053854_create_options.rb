# frozen_string_literal: true

# Create Options
class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :content, null: false
      t.boolean :correct_op, default: false

      t.timestamps
    end
  end
end
