module Notifier
  class Slack < ApiGateway::Base

    def initialize(webhook)
      self.class.base_uri webhook
    end

    def notify_successful_invitation(name, email)
      message = "#{name} (#{email}) has been successfully invited."
      data = {
          attachments: [{
                            fallback: message,
                            text: message,
                            color: 'good'
                        }]
      }

      make_post('', body: data.to_json)
    end

    def notify_failed_invitation(name, email, error_message)
      message = "Error while trying to invite #{name} (#{email})."
      data = {
          attachments: [{
                            fallback: message,
                            text: message,
                            color: 'danger',
                            fields: [{
                                         title: 'Error',
                                         value: error_message
                                     }]
                        }]
      }

      make_post('', body: data.to_json)
    end

  end
end
