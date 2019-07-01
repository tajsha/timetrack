# == Schema Information
#
# Table name: time_tracks
#
#  id              :integer          not null, primary key
#  project_id      :integer
#  user_id         :integer
#  number_of_hours :integer
#  description     :string
#  work_date       :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  label           :string
#
# Indexes
#
#  index_time_tracks_on_project_id  (project_id)
#  index_time_tracks_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_5e17090c48  (user_id => users.id)
#  fk_rails_7e191ce762  (project_id => projects.id)
#

class TimeTrack < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :histories, :as => :trackable
  has_and_belongs_to_many :labels, :join_table => :time_tracks_labels, :dependent => :destroy

  validates :project, presence: true
  validates :user, presence: true
  validates :number_of_hours, presence: true
  validates :description, presence: true
  validates :work_date, presence: true

  attr_accessor :label

end
