class AddHistoryMetadataToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :history_metadata, :text
  end
end
