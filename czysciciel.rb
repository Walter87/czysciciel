require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'google-api-client'
  gem 'pry'
  gem 'celluloid'
end

puts 'Gems installed and loaded!'

require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require 'celluloid/current'
require 'logger'

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "Czysciciel".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::GmailV1::AUTH_SCOPE

class Worker
  include Celluloid
  Celluloid.shutdown_timeout = 30
  Celluloid.logger = ::Logger.new("celluloid.log")

  def process_batch(user_id, service, msg, index)
    puts "Started removing page number #{index+1}"
    ids_to_delete = msg.map(&:id)
    request_object = Google::Apis::GmailV1::BatchDeleteMessagesRequest.new
    request_object.ids = ids_to_delete

    service.batch_delete_messages(user_id, request_object)

    puts "Removed page nr #{index+1} of #{msg.count} messages"
  end
end

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#

# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

user_id = "me"
puts 'Type in google filter same you would use in google gmail client ie: from:support@datafeedwatch.com;older_than:1y'
filter = gets.chomp

if filter.size < 5
  puts 'Your filter seems to be too short. Exiting'
  exit!
end

puts 'Collecting ids of emails. Please wait, it can take some time...'

messages = service.fetch_all(items: :messages) do |token|
  service.list_user_messages(
                              user_id,
                              q: filter,
                              page_token: token
                            )
end

if messages.count.zero?
  puts "No Messages found"
else
  worker_pool = Worker.pool(size: 5)
  futures = []

  puts "#{messages.count} found with used filter and will be removed permanently. Type 'y' and click enter to continue or 'n' to exit"

  while user_input = gets.chomp # loop while getting user input
    case user_input
    when 'y'
      puts 'removing messages'
      break
    when 'n'
      exit!
    else
      puts "Please select either 'y' or 'n'"
    end
  end

  messages.each_slice(1000).with_index do |msg, index|
    futures.push(worker_pool.future(:process_batch, user_id, service, msg, index))
  end

  futures.each(&:value)

  puts "Totaly remove #{messages.count} messages. Enjoy Your free space now."
end
