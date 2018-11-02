class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.float :rate_average
      t.string :thumbnail
      t.references :user
      t.references :category

      t.timestamps
    end
  end
end
