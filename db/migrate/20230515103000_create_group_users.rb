class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :group, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
