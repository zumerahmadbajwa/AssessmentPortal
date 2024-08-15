class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score
      t.text :answers
      t.timestamps
    end
  end
end
