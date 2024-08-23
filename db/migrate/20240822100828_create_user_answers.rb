class CreateUserAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :selected_option, null: false, foreign_key: { to_table: :options }

      t.timestamps
    end
  end
end
