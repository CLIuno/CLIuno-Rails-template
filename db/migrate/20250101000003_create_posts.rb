class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts, id: :string do |t|
      t.string :title, null: false
      t.text :content
      t.string :image_url
      t.boolean :is_paid, default: false
      t.references :user, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
