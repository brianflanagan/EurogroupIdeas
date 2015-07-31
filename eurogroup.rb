require 'twitter'
require './policy_deviser'

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

$stdout.sync = true

loop do
  msg = nil

  while msg.nil? or (msg.size < 1) or (msg.size > (140 - 'RT EuroGroupIdeas'.size)) do
    msg = PolicyDeviser.generate_policy + ' #eurogroup'
  end

  puts " >> " + msg

  response = $twitter.update(msg)
  puts " >> >> posted: http://twitter.com/#{ response.user.screen_name }/status/#{ response.id.to_s }"

  sleep 15 * 60
end