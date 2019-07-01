class AddLabelToTimetracks < ActiveRecord::Migration
  def change
    add_column :time_tracks, :label, :string
  end
end
