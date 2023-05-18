class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }, type: :bigint
      t.references :followed, null: false, foreign_key: { to_table: :users }, type: :bigint

      t.timestamps
    end
  end
end

# class CreateRelationships < ActiveRecord::Migration[6.1]
#   def change
#     create_table :relationships do |t|
#       t.bigint :follower_id
#       t.bigint :followed_id

#       t.timestamps
#     end
#     add_index :relationships, [:follower_id, :followed_id], unique: true
#     add_foreign_key :relationships, :users, column: :follower_id, on_delete: :cascade
#     add_foreign_key :relationships, :users, column: :followed_id, on_delete: :cascade
#   end
# end
