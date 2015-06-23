class CreateDirectMessages < ActiveRecord::Migration
  def change
    create_table :direct_messages do |t|
      t.text :content
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps null: false
    end

    add_index :direct_messages, [:from_user_id, :to_user_id, :created_at], name: "triple_index"
  end
end
