# == Schema Information
#
# Table name: histories
#
#  id               :integer          not null, primary key
#  title            :string           not null
#  user_id          :integer          not null
#  trackable_name   :string           not null
#  trackable_type   :string           not null
#  trackable_id     :integer          not null
#  project_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  history_metadata :text
#

class History < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :user
  belongs_to :project

  serialize :history_metadata

  TIMETRACK_TRACKABLE_NAMES = {'new_timetrack' => 'new_timetrack',
                               'update_timetrack' => 'update_timetrack',
                               'delete_timetrack' => 'delete_timetrack'}
  HISTORY_TITLES = {
                     'new_timetrack' => 'New Time Track Added',
                     'update_timetrack' => 'Time Track Updated',
                     'delete_timetrack' => 'Time Track Deleted'
                   }

  def self.add_history(track_obj, user, trackable_name)
    history = History.new
    history.title = HISTORY_TITLES[trackable_name]
    history.trackable_name = TIMETRACK_TRACKABLE_NAMES[trackable_name]
    history.user = user
    history.trackable = track_obj
    history.project_id = track_obj.project.present? ? track_obj.project.id : nil
    history.history_metadata = track_obj.attributes
    history.save!
  end

end
