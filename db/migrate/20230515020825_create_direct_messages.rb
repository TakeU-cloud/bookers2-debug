class CreateDirectMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content

      t.timestamps
    end
    add_index :direct_messages, [:sender_id, :receiver_id]
    add_foreign_key :direct_messages, :users, column: :sender_id, on_delete: :cascade
    add_foreign_key :direct_messages, :users, column: :receiver_id, on_delete: :cascade
  end
end
