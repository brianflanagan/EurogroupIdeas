require 'twitter'

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

# ideomatic policy ideas:
# Here's an idea: Ireland should subcontract its water infrastructure!
# Hear me out: What if Portugal launched tenders for gambling permits?
# Think about this: Greece could increase competitive tendering in its fishing industry.

INTRODUCTORY_REMARKS = [
  'Hear me out…',
  'Here\'s an idea',
  'Think about this:',
  'What about this?',
  'Consider this:',
  'I have an idea!',
  'Here\'s a thought…'
]

DEBTOR_NATIONS = ['Greece', 'Italy', 'Ireland', 'Portugal', 'Spain']

INDUSTRIES = ['aeronautics ', 'automotive', 'biotechnology', 'chemicals', 'construction', 'defence', 'electrical engineering', 'fashion', 'food', 'footwear', 'furniture', 'healthcare', 'leather', 'legal metrology and pre-packaging', 'maritime', 'mechanical engineering', 'mining, metals and minerals', 'pressure equipment and gas appliances', 'radio and telecommunications terminal equipment', 'raw materials', 'satellite navigation', 'smart regulation', 'social entrepreneurship', 'space', 'textiles and clothing', 'tourism', 'toys', 'wood', 'paper', 'printing']

def policy_idea_for_country(country)
  case [:privatisation,:competition].sample
  when :competition
    "#{ country} should build a primier #{ INDUSTRIES.sample } hub to increase innovation."
  when :privatisation
    synonyms = ['privatise','subcontract']
    "#{ country} should #{ synonyms.sample } its #{ INDUSTRIES.sample } industry."
  end
end

def eurogroup_policy_idea
  policy_idea = ''

  while (policy_idea.size < 1) || (policy_idea.size > (140 - 'RT EuroGroupIdeas'.size)) do
    policy_idea = "#{ INTRODUCTORY_REMARKS.sample } #{ policy_idea_for_country(DEBTOR_NATIONS.sample) }"
  end

  policy_idea
end

$stdout.sync = true

loop do
  msg = eurogroup_policy_idea
  puts " >> " + msg

  response = twitter.update(msg)
  puts " >> >> posted: http://twitter.com/#{ response.user.screen_name }/status/#{ response.id.to_s }"

  sleep 5
end