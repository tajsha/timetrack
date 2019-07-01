class AdIndexToJoinTables < ActiveRecord::Migration
  def change
    add_index :users_companies, [ :user_id, :company_id ], :unique => true, :name => 'by_user_and_company'
    add_index :users_projects, [ :user_id, :project_id ], :unique => true, :name => 'by_user_and_project'
    change_column :users, :name, :string, null: false
  end
end
