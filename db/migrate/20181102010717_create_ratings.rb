class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.references :user
      t.references :course

      t.timestamps
    end
  end
end
