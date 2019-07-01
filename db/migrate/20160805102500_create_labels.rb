class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name, :null => false, :unique => true
      t.timestamps null: false
    end

    remove_column :time_tracks, :label

    create_table :time_tracks_labels do |t|
      t.references :label, :null => false
      t.references :time_track, :null => false
    end

    add_index :time_tracks_labels, [ :label_id, :time_track_id ], :unique => true, :name => 'by_time_track_and_label'

  end
end
