class ReceiptEmailSender
  def initialize(form_id, response_token, email)
    @form_id = form_id
    @response_token = response_token
    @email = email
  end

  def send_email
    update_charge(user_charge.id)

    handle_success
  rescue Exception => error
    handle_error(error)
  end

  private

  def user_charge
    return @charge if @charge
    charge = stripe_api.list(limit: 10).find do |charge|
      charge.metadata.typeform_form_id == @form_id &&
        charge.metadata.typeform_response_id == @response_token
    end

    raise RuntimeError, "Charge not found in Stripe for email #{@email}" unless charge

    @charge = charge
  end

  def update_charge(charge_id)
    stripe_api.update(charge_id,
                      receipt_email: @email,
                      description: "Membership - Startups BCN Community on Slack")
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
