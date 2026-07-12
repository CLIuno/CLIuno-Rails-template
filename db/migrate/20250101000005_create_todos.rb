class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos, id: :string do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :is_completed, default: false
      t.references :user, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
