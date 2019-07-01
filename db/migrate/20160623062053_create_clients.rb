class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :company, index: true, foreign_key: true
      t.string :name
      t.string :address

      t.timestamps null: false
    end
  end
end
