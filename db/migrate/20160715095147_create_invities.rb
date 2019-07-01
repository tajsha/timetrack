class CreateInvities < ActiveRecord::Migration
  def change
    create_table :invities do |t|
      t.string :email
      t.integer :company_id
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token
      t.timestamps
    end
  end
end
