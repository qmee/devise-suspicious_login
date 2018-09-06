class AddTrackableColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      add_column :users, :last_sign_in_at, :datetime
      add_column :users, :current_sign_in_at, :datetime
      add_column :users, :current_sign_in_ip, :string
      add_column :users, :last_sign_in_ip, :string
      add_column :users, :sign_in_count, :integer, default: 0, null: false
    end
  end
end
