class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.string :name
      t.string :body_part
      t.string :difficulty
      t.integer :duration
      t.string :equipment_required
      t.string :image_url
      t.text :instructions

      t.timestamps
    end
  end
end
