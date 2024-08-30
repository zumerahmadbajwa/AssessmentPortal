# frozen_string_literal: true

# Add Colum to Users
class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
  end
end
