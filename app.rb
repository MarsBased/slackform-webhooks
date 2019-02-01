require 'sinatra'
require 'httparty'
require 'dotenv/load'

require './app/api_gateway/base'
require './app/api_gateway/slack'

require './app/notifier/default'
require './app/notifier/slack'

require './app/slack_inviter'
require './app/typeform_event'

post '/' do
  params = JSON.parse(request.body.read)
  event = TypeformEvent.new(params)

  if event.response?
    first_name = event.answer_for_field(ENV['FIRST_NAME_FIELD_ID'])
    last_name = event.answer_for_field(ENV['LAST_NAME_FIELD_ID'])
    email = event.answer_for_field(ENV['EMAIL_FIELD_ID'])

    SlackInviter.new.invite(first_name, last_name, email)
  end
end
