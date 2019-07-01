class InviteMailer < ApplicationMailer

  def existing_user_invite(invite)
    @invite = invite
    mail(to: @invite.email, subject: "Invitation to join the #{@invite.company.name} Projects")
  end

  def new_user_invite(invite, url)
    @invite = invite
    @url = url
    mail(to: @invite.email, subject: "Invitation to join the #{@invite.company.name} Projects")
  end

end
