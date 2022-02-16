module Notifier
  class Slack < ApiGateway::Base

    def initialize(webhook)
      self.class.base_uri webhook
    end

    def notify_successful_invitation(name, email)
      message = "#{name} (#{email}) has been successfully invited."

      send_message(success_message_payload(message))
    end

    def notify_failed_invitation(name, email, error_message)
      message = "Error while trying to invite #{name} (#{email})."

      send_message(error_message_payload(message, error_message))
    end

    def notify_successfully_sent_receipt_email(email)
      message = "Receipt email sent to #{email}."

      send_message(success_message_payload(message))
    end

    def notify_failed_sending_receipt_email(email, error_message)
      message = "Error while trying to send receipt email to #{email}."

      send_message(error_message_payload(message, error_message))
    end

    private

    def send_message(payload)
      make_post('', body: payload.to_json)
    end

    def success_message_payload(message)
      { attachments: [{ fallback: message, text: message, color: 'good' }] }
    end

    def error_message_payload(message, error_message)
      { attachments: [{ fallback: message,
                        text: message,
                        color: 'danger',
                        fields: [{ title: 'Error', value: error_message }] }] }
    end
  end
end
