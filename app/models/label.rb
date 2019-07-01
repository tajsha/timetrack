# == Schema Information
#
# Table name: labels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Label < ActiveRecord::Base
  has_and_belongs_to_many :time_tracks, :join_table => :time_tracks_labels
  validates :name, presence: true, uniqueness: true
end
