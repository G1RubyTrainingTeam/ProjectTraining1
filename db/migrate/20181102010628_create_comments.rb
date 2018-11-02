class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :parent_id
      t.references :user
      t.references :course

      t.timestamps
    end
  end
end
