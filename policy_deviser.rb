require 'engtagger'
require 'wordnet'

class PolicyDeviser
  def self.generate_policy
    country = choose_country
    noun = nil

    while !noun do
      noun, username = find_noun_and_username_for_country(country)
    end

    case [:urge, :behove].sample
    when :urge
      "We #{ urge_predicate } #{ country[:name] } to privatise its #{ noun }. /cc @#{ username }"
    when :behove
      "It #{ behove_predicate } #{ country[:name] } to privatise its #{ noun }. /cc @#{ username }"
    end
  end

private

  def self.urge_predicate
    adverb = ['strongly','emphatically','enthusiastically','passionately','exuberantly','fervently',nil].sample
    verb = ['urge','pressure','encourage','admonish','beseech','exhort'].sample
    [adverb, verb].compact.join(' ')
  end

  def self.behove_predicate
    ['behoves', 'is incumbent on', 'would be prudent for', 'is advisable for', 'is sensible for'].sample
  end

  def self.privatise_synonym
    ['privatise','subcontract'].sample
  end

  def self.find_noun_and_username_for_country(country)
    $twitter.search("lang:en -rt #{ country[:demonym] }", result_type: "recent", count: 100).take(100).to_a.shuffle.each do |tweet|
      word = get_noun_after_demonym(tweet.text.downcase, country[:demonym])

      next unless word && word.size > 2

      puts " >> " + tweet.text
      return [word, tweet.user.username]
    end

    nil
  end

  def self.get_noun_after_demonym(tweet_text, country_demonym)
    tgr = EngTagger.new
    tagged = tgr.add_tags(tweet_text)
    nouns = tgr.get_noun_phrases(tagged).keys.sort_by { |i| i.length }.reverse
    nouns.each do |noun|
      o_noun = noun.scan(/^[^[@\.,]]+/).first # ignore weird stuff
      next unless tweet_text.include?("#{ country_demonym } #{ o_noun }")
      next unless is_noun?(o_noun.split(' ').last)

      return o_noun
    end

    nil
  end

  def self.is_noun?(word)
    lemma = WordNet::Lemma.find(word, :noun)
    return !lemma.nil?
  end

  def self.choose_country
    [
      {name: 'Portugal', demonym: 'portuguese'},
      {name: 'Ireland', demonym: 'irish'},
      {name: 'Italy', demonym: 'italian'},
      {name: 'Greece', demonym: 'greek'},
      {name: 'Spain', demonym: 'spanish'},
      {name: 'Portugal', demonym: "portugal's"},
      {name: 'Ireland', demonym: "ireland's"},
      {name: 'Italy', demonym: "italy's"},
      {name: 'Greece', demonym: "greece's"},
      {name: 'Spain', demonym: "spain's"}
    ].sample
  end
end