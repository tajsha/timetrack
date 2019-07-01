# == Schema Information
#
# Table name: users_companies
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  company_id :integer
#  role       :string(255)
#
# Indexes
#
#  by_user_and_company                  (user_id,company_id) UNIQUE
#  index_users_companies_on_company_id  (company_id)
#  index_users_companies_on_user_id     (user_id)
#

class UsersCompany < ActiveRecord::Base
   belongs_to :user
   belongs_to :company

   after_create :assign_admin_role_to_user

   ROLES = ["admin","tester","project_manager","developer"]


   def assign_admin_role_to_user
     if self.company.users.count == 0
       self.role = 'admin'
     else
       self.role = 'developer'
     end
     self.save!
   end

   def self.user_role(company_id,user_id)
    role = where(:company_id => company_id, :user_id => user_id)
    role.first.role
   end
end
