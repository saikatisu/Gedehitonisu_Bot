require './api/TwitterReception'
require './api/TwitterClient'
require "./common/Constantlist.rb"
require './action/TweetReply.rb'
require './action/UsuallyTweet'
require 'jp_prefecture'

ENV["SSL_CERT_FILE"] = './config/cacert.pem'

@usuallyTweet = UsuallyTweet.new
@tweetReply = TweetReply.new

begin

	# y = Thread.new do
	   loop do

		    @tweetReply.weatherResponsetext("東京都")
		    sleep(60*10)

		    @usuallyTweet.companyCountTweet()
		    sleep(60*10)

		    @usuallyTweet.nicoVideoTweet()
		    sleep(60*10)

		   	@usuallyTweet.characterTweet()
		    sleep(60*10)

		    @usuallyTweet.trendsTweet()
		    sleep(60*10)

		    @usuallyTweet.youtubeTweet()
		    sleep(60*10)

		    @usuallyTweet.wagesTweet()
		    sleep(60*10)

		    @usuallyTweet.fgoTweet()
		    sleep(60*10)

		    @usuallyTweet.nintendoTweet()
		    sleep(60*10)

 		end
	# end

	# twitterReception = Thread.new do
	# 	TwitterReception.new
	# end
	# # joinがないと警告なしでスレッドが終了
	# twitterReception.join
	
rescue => e
  puts "例外が発生しました"
  puts e.message
end


