class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :title, :null => false
      t.references :user, :null => false
      t.string :trackable_name, :null => false
      t.string :trackable_type, :null => false
      t.integer :trackable_id, :null => false
      t.references :project

      t.timestamps null: false
    end
  end
end
