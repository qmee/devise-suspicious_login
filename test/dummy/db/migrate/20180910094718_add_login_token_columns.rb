class AddLoginTokenColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      add_column :users, :login_token, :string
      add_column :users, :login_token_sent_at, :datetime
    end
  end
end
