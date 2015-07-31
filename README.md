# EurogroupIdeas
A simple twitterbot capable of complex neo-liberal economics.

Written in Ruby. Will run on Heroku. Requires a little config to work with _your_ twitter account:

```
CONSUMER_KEY=YOUR_TWITTER_CONSUMER_KEY
CONSUMER_SECRET=YOUR_TWITTER_CONSUMER_SECRET
ACCESS_TOKEN=YOUR_TWITTER_ACCESS_TOKEN
ACCESS_TOKEN_SECRET=YOUR_TWITTER_ACCESS_TOKEN_SECRET
```

Here's what it does:

Every 15 minutes, it:

- chooses a European debtor nation (Portugal, Ireland, Italy, Greece, Spain)
- finds a tweet that mentions something that nation has (`Irish stout`, `Italian Senate`)
- recommends that the debtor nation privatize that particular noun

So stupidly simple it almost seems like these policies wouldn't work...
