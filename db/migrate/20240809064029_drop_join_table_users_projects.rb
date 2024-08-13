class DropJoinTableUsersProjects < ActiveRecord::Migration[5.2]
  def up
    drop_table :projects_users, if_exists: true
  end

  def down
    create_join_table :users, :projects do |t|
      t.index :user_id
      t.index :project_id
    end
  end
end
