class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows, id: :string do |t|
      t.references :follower, type: :string, null: false, foreign_key: { to_table: :users }
      t.references :following, type: :string, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :follows, %i[follower_id following_id], unique: true
  end
end
