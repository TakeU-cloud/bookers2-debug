class CreateGroupMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :group_messages do |t|
      t.references :group, null: false, foreign_key: { to_table: :groups }
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
