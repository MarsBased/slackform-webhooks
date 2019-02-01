class SlackInviter

  Invitation = Struct.new(:first_name, :last_name, :email) do
    def full_name
      "#{first_name} #{last_name}"
    end
  end

  def invite(first_name, last_name, email)
    invitation = Invitation.new(first_name, last_name, email)

    response = slack_api.invite(email, first_name, last_name)

    handle_invite_response(invitation, response)
  end

  private

  def handle_invite_response(invitation, response)
    if response['ok']
      notifier.notify_successful_invitation(invitation.full_name, invitation.email)
    else
      notifier.notify_failed_invitation(invitation.full_name, invitation.email, response['error'])
    end
  end

  def slack_api
    @slack_api ||= ApiGateway::Slack.new(token: ENV['SLACK_API_KEY'], slack_team: ENV['SLACK_TEAM'])
  end

  def notifier
    @notifier ||= Notifier::Slack.new(ENV['SLACK_NOTIFICATIONS_WEBHOOK'])
  end
end
