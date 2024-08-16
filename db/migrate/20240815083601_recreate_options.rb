class RecreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.references :question, foreign_key: true
      t.string :content
      t.boolean :correct, default: false
      t.timestamps
    end
  end
end
