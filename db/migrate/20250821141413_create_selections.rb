class CreateSelections < ActiveRecord::Migration[8.0]
  def change
    create_table :selections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :duration_seconds

      t.timestamps
    end
  end
end
