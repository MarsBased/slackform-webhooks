require 'sinatra'
require 'httparty'
require 'dotenv/load'

require './app/api_gateway/base'
require './app/api_gateway/slack'

require './app/notifier/default'
require './app/notifier/slack'

require './app/slack_inviter'
require './app/typeform_response'

post '/' do
  payload = request.body.read

  if ENV['TYPEFORM_SECRET']
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['TYPEFORM_SECRET'], payload)
    actual_signature = 'sha256=' + Base64.strict_encode64(hash)

    unless Rack::Utils.secure_compare(actual_signature, request.env['HTTP_Typeform-Signature'])
      return halt 500, "Signatures don't match!"
    end
  end

  params = JSON.parse(payload)
  event = TypeformResponse.new(params)

  if event.response?
    first_name = event.answer_for_field(ENV['FIRST_NAME_FIELD_ID'])
    last_name = event.answer_for_field(ENV['LAST_NAME_FIELD_ID'])
    email = event.answer_for_field(ENV['EMAIL_FIELD_ID'])

    SlackInviter.new.invite(first_name, last_name, email)
  end
end
