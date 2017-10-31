import tweepy
from tweepy import OAuthHandler

consumer_key = '0gAayYK2Vwe8F4iSXi2iH3Pab'
consumer_secret = '[your consumer secret key]'
access_token = '771729361-bzOsfxYRYU9fiAgrm9X7vBisoDxJVs9ertkxidIt'
access_secret = '[your access secret key]'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

api = tweepy.API(auth)

from tweepy import Stream
from tweepy.streaming import StreamListener

#override tweepy.StreamListener to add logic to on_status
class MyStreamListener(tweepy.StreamListener):

    def on_status(self, status):
        tweett=status.text.encode('utf-8')
        timet=status.created_at
        totext=tweett + '\t' + str(timet)
        print(totext)

    def on_error(self, status_code):
        if status_code == 420:
            #returning False in on_data disconnects the stream
            return False

twitter_stream = Stream(auth, MyStreamListener())
twitter_stream.filter(track=['Bitcoin', 'bitcoin','#XBT', '#BTC', 'XBT','BTC', '$BTC', '$XBT' '#Bitcoin', '$LTC', 'Litecoin', 'litecoin', '#LTC', 'LTC', '#Litecoin', '$ETH', '#ETH', 'ETH', 'Ethereum', 'ethereum'])
