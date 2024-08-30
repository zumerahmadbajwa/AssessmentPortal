# frozen_string_literal: true

# Create ProjectUsers
class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end

    add_index :project_users, %i[user_id project_id], unique: true
  end
end
