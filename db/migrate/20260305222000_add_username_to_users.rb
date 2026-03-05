class AddUsernameToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :username, :string

    execute <<~SQL
      UPDATE users
      SET username = lower(split_part(email, '@', 1))
      WHERE username IS NULL AND email IS NOT NULL
    SQL

    execute <<~SQL
      UPDATE users u
      SET username = u.username || '_' || u.id
      WHERE EXISTS (
        SELECT 1 FROM users u2
        WHERE u2.id <> u.id AND u2.username = u.username
      )
    SQL

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
  end
end
