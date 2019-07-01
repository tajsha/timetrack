# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clients_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_db0f958971  (company_id => companies.id)
#

class Client < ActiveRecord::Base
  belongs_to :company
  has_many :projects
  validates :name, presence: true
  validates :company, presence: true
  validates :address, presence: true
end
