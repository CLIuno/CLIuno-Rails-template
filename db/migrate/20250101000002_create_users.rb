class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :string do |t|
      t.string :username, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date_of_birth
      t.string :gender
      t.string :nationality
      t.string :phone
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :is_online, default: false
      t.boolean :is_deleted, default: false
      t.string :refresh_token
      t.references :role, type: :string, foreign_key: true

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
