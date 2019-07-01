# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  client_id   :integer
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_projects_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_8d9657cec3  (client_id => clients.id)
#

class Project < ActiveRecord::Base
  belongs_to :client
  has_many :time_tracks
  validates :name, presence: true
  validates :client, presence: true
  validates :description, presence: true
end
