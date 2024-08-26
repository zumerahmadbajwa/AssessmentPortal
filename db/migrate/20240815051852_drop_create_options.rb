# frozen_string_literal: true

# DropCreateOptions
class DropCreateOptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :options
  end
end
