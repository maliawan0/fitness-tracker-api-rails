class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :age
      t.decimal :weight
      t.string :gender
      t.text :goals
      t.string :muscle_focus
      t.string :intensity

      t.timestamps
    end
  end
end
