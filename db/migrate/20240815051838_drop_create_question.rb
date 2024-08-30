# frozen_string_literal: true

# Drop Create Question
class DropCreateQuestion < ActiveRecord::Migration[5.2]
  def change
    drop_table :questions
  end
end
