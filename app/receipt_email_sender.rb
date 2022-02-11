class ReceiptEmailSender
  def initialize(form_id, response_token, email)
    @form_id = form_id
    @response_token = response_token
    @email = email
  end

  def send_email
    return unless user_charge
    return unless update_charge(user_charge.id)

    handle_success
  end

  private

  def user_charge
    @charge ||= safe_stripe_call do
      charge = stripe_api.list(limit: 10).find do |charge|
        charge.metadata.typeform_form_id == @form_id &&
          charge.metadata.typeform_response_id == @response_token
      end

      raise RuntimeError, "Charge not found" unless charge

      charge
    end
  end

  def update_charge(charge_id)
    safe_stripe_call { stripe_api.update(charge_id, receipt_email: @email) and :OK }
  end

  def safe_stripe_call
    yield
  rescue Exception => error
    handle_error(error)

    nil
  end

  def handle_success
    notifier.notify_successfully_sent_receipt_email(@email)
  end

  def handle_error(error)
    notifier.notify_failed_sending_receipt_email(@email, error.message)
  end

  def stripe_api
    return @stripe_api if @stripe_api

    ::Stripe.api_key = ENV['STRIPE_SECRET']
    @stripe_api = ::Stripe::Charge
  end

  def notifier
    @notifier ||= Notifier::Slack.new(ENV['SLACK_NOTIFICATIONS_WEBHOOK'])
  end
end
