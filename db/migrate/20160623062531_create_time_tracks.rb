class CreateTimeTracks < ActiveRecord::Migration
  def change
    create_table :time_tracks do |t|
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :number_of_hours
      t.string :description
      t.date :work_date, :null => false

      t.timestamps null: false
    end
  end
end
