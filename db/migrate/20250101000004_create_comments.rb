class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments, id: :string do |t|
      t.text :content, null: false
      t.references :user, type: :string, null: false, foreign_key: true
      t.references :post, type: :string, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
