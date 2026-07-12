class AddAuthFeaturesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :is_otp_enabled, :boolean, default: false
    add_column :users, :is_verified, :boolean, default: false
    add_column :users, :verify_token, :string
    add_column :users, :reset_password_token, :string
  end
end
