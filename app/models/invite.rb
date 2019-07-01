# == Schema Information
#
# Table name: invities
#
#  id           :integer          not null, primary key
#  email        :string
#  company_id   :integer
#  sender_id    :integer
#  recipient_id :integer
#  token        :string
#  created_at   :datetime
#  updated_at   :datetime
#

class Invite < ActiveRecord::Base
  self.table_name = 'invities'
  belongs_to :company
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  before_create :generate_token

  before_save :check_user_existence

  def check_user_existence
    recipient = User.find_by_email(email)
    if recipient
      self.recipient_id = recipient.id
    end
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.company_id, Time.now, rand].join)
  end
end
