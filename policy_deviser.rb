require 'wordnet'

class PolicyDeviser
  def self.generate_policy
    country = choose_country
    noun = find_noun_for_country(country)

    "We #{ predicate } #{ country[:name] } to privatise its #{ noun }."
  end

private

  def self.predicate
    adverb = ['strongly','emphatically','enthusiastically','passionately','exuberantly','fervently',nil].sample
    verb = ['urge','pressure','encourage','admonish','beseech','exhort'].sample
    [adverb, verb].compact.join(' ')
  end

  def self.find_noun_for_country(country)
    $twitter.search("lang:en -rt #{ country[:demonym] }", result_type: "recent").take(10).collect do |tweet|
      word = get_word_after_demonym(tweet.text.downcase, country[:demonym])

      next unless word && word.size > 2

      puts " >> " + tweet.text
      return word if is_noun?(word)
    end
  end

  def self.get_word_after_demonym(tweet_text, country_demonym)
    tweet_text.split(country_demonym).last.strip.scan(/^[a-zA-Z]+/).first
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
      {name: 'Spain', demonym: 'spanish'}
    ].sample
  end
end