class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :video_url
      t.references :course

      t.timestamps
    end
  end
end
