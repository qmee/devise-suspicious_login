class AddRecoverableColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      add_column :users, :reset_password_token, :string
      add_column :users, :reset_password_sent_at, :datetime
    end
  end
end
