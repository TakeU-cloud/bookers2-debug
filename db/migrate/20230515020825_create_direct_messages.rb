class CreateDirectMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_messages do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }, type: :bigint
      t.references :receiver, null: false, foreign_key: { to_table: :users }, type: :bigint
      t.string :content

      t.timestamps
    end
  end
end
