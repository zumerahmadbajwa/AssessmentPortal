class DropCreateOptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :options
  end
end
