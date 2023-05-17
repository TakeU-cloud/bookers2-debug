class AddScoreToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :score, :integer, null: false, default: 0
  end
end
