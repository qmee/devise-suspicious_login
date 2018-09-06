class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :unique_session_id, :limit => 20

      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.datetime :password_changed_at
      t.timestamps null: false
    end
    add_index :users, :password_changed_at
    add_index :users, :email
  end
end
