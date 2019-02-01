# Slackform

Slackform is a Sinatra web application to receive Webhook requests from a Typeform form and invite new members to a Slack team with the data provided in the form answer (first name, last name and email).

For each Webhook request it receives, it sends an invitation to the user to join the configured Slack team.

The Typeform form needs to be configured to add a Webhook pointing to the URL where this app is hosted.

## Installation

### Dependencies

* Ruby 2.5.3
* Git (needed to clone the repo in order to install the gem)

### How to install

Follow these steps to install:

1. Clone this repository: ```git clone https://github.com/MarsBased/slackform```
2. Install gems: `bundle install`
3. Configure environment variables. Use `.env.sample` to see the variables that need to be configured.

## Running

Just run `ruby app.rb`. It will start listening on port 4567. If you want to test this with a real Typeform form you can use Ngrok to create a tunnel to your locally running server.

## Configuration

Slackform is configured by using environment variables. In development, it includes `dotenv` to make it easier to configure, just create a `.env` file with all the variables. These are the variables you need to configure:

- **SLACK_API_KEY:** You can find it in the Slack API page while you are logged in your Slack team. Go to the [Slack Web API page](https://api.slack.com/web) and in the "Authentication" section you will be able to see or create the token for the team. Note that in this page you will see the API tokens for all the Slack teams where you are registered. Just copy the token of the team where you want to invite the new members.
- **SLACK_TEAM:** This is the name of the Slack team where you want to invite new members. This is just your Slack subdomain. For example, if you access Slack through ```https://coolteam.slack.com```, then the Slack team is ```coolteam```
- **EMAIL_FIELD_ID, FIRST_NAME_FIELD_ID and LAST_NAME_FIELD_ID:** A Slack invitation consists of 3 parameters: an email (required), a first name (optional) and a last name (optional). This variables are used to specify the Typeform fields that are used to extract each of the parameters. For each invitation parameter you need to specify the Typeform field id that will be used. See [how to check a typeform field id](#how-to-check-a-typeform-field-id) for details.
- **TYPEFORM_SECRET: (Optional)** The secret configured in the Typeform Webhook.
### How to check a Typeform field ID

Follow these steps:

1. Open the Form edition page
![image](https://cloud.githubusercontent.com/assets/3403704/11236413/bb45c554-8dd9-11e5-8f03-9f3dbb611d30.png)

2. Check the HTML of the field. In Chrome and other browsers you can just "Inspect Element" on the field.
![image](https://cloud.githubusercontent.com/assets/3403704/11236582/f57f2340-8dda-11e5-8d56-65b039952910.png)

3. Find the parent ```<li>``` element for the field and check its ```id``` attribute, it should be something like: ```field-12345678```
![image](https://cloud.githubusercontent.com/assets/3403704/11236716/b2af6c68-8ddb-11e5-9e50-5782336e8cce.png)

4. Finally remove the "field-" part and that's your id. For example, for "field-12345678" it would be "12345678".

**NOTE:** This is assuming you are using textfields in your form, if you use other type of fields (like text areas), then replace the "textfield" part by "textarea" or whatever type of field.

### Slack notifications

For each invitation, a notification to Slack is also sent. Each time it tries to invite someone (because there is a new answer in the Typeform) it will either send a "success" message or an "error" message to the Slack channel.

You can configure it to send a message to any Slack channel of any team (not necessarily the same team you are integrating Typeform with).

To configure notifications, add the following variable:

- **SLACK_NOTIFICATIONS_WEBHOOK:** a Slack "Incoming Webhook", which is like a regular URL, and tells Slack where to post the messages.

Follow these steps to configure a new Webhook:

1. Open the Slack administration panel for the team where you want notifications to be posted. For example: ```https://coolteam.slack.com/admin```
2. In the side menu go to "Integrations"
3. Click "View" on "Incoming WebHooks"

Now you need to configure the integration:

4. Select the channel where you want notifications to be posted
5. Click on "Add Incoming WebHooks integration"
6. Copy the "Webhook URL". This is the URL you need to use in the YAML configuration.
7. In "Integration Settings", configure the details of the integration as you wish, the different settings are self-explanatory.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MarsBased/slackform.

## Update Lambda function

Just ZIP everything and upload as a ZIP, remember to include all gems in the bundle and install any new gems with `bundle install --path vendor/bundle`.
