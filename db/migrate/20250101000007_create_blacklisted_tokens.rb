class CreateBlacklistedTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :blacklisted_tokens, id: :string do |t|
      t.string :token, null: false
      t.datetime :invalidated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end

    add_index :blacklisted_tokens, :token, unique: true
  end
end
