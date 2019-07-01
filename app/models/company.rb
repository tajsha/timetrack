# == Schema Information
#
# Table name: companies
#
#  id                  :integer          not null, primary key
#  name                :string
#  number_of_employees :integer
#  address             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Company < ActiveRecord::Base
  has_many :users_companies
  has_many :users, :through => :users_companies
  has_many :clients
  has_many :projects, :through => :clients
  has_many :invites
  validates :name, presence: true
  attr_accessor :members_emails
end
