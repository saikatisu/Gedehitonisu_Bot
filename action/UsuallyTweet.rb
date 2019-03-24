require './api/TwitterClient'
require "./common/Constantlist.rb"
require './api/NicoVideoApi'
require './api/YoutubeApi'
require './api/ReSasApi'
require './api/RssApi'
require 'logger'
require 'time'

class UsuallyTweet

	def initialize()
		@twitterClient = TwitterClient.new
		@nicoVideoApi = NicoVideoApi.new
		@youtubeApi = YoutubeApi.new
		@log = Logger.new(STDOUT)
		@reSasApi =ReSasApi.new
		@rssApi = RssApi.new
	end

	def characterTweet()
		File.open(Constantlist::BOTTWEET, "r") do |bot|
	      @bots = bot.read.split("\n")
	    end
	    @twitterClient.twieet(@bots.sample)
	end

	def trendsTweet()
		@res = @twitterClient.trends()
		@word = @res[:trends].sample[:name]
		@log.debug(@word)
		@tweet = "「#{@word}」が話題になっているようです。\n 人類の言語は常に変化しておりますゆえ、その本来の意味に注目しなければなりません。"
		@log.debug(@tweet)
		@twitterClient.twieet(@tweet)
	end

	def nicoVideoTweet()
		#ランダムタグ生成
		@randomtarget = NicoVideoApi::TARGETLIST.keys.sample
		@randomperiod = NicoVideoApi::PERIODLIST.keys.sample
		@randomcategory = NicoVideoApi::CATEGORYLIST.keys.sample

		@targetword = NicoVideoApi::TARGETLIST[@randomtarget]
		@periodword = NicoVideoApi::PERIODLIST[@randomperiod]
		@categoryword = NicoVideoApi::CATEGORYLIST[@randomcategory]

		@res = @nicoVideoApi.getRanking(@randomtarget , @randomperiod , @randomcategory)
		@title = @res["channel"][0]["item"][0]["title"].to_s.delete("第1位：\"[]")
		@url = "http://nico.ms/#{@res["channel"][0]["item"][0]["link"].to_s.match(/s.\d*/)}?ref=twitter"
		puts @url
		@tweet = "現在、ニコニコ動画では以下の動画が話題になっているようです。\n[対象] #{@targetword}\n[期間] #{@periodword}\n[カテゴリ] #{@categoryword}\n[タイトル] #{@title}\n #{@url}"

		@log.debug(@tweet)
		@log.debug("文字数：#{@tweet.length}")

		@twitterClient.twieet(@tweet)
	end

	def youtubeTweet()

		#再生リストID
		@playlistId = "PLuXL6NS58Dyztg3TS-kJVp58ziTo5Eeck&key=AIzaSyAxCGQJuT0rcONUvCynarpmx1ZMS9MeN3M"

		#取得動画数
		@maxItem = 50

		#HTTPリクエストを送信	
		@res = @youtubeApi.videolList(nil,@playlistId,@maxItem)

		#ツイートする動画をランダムで取得	
		@randomid = (0..@maxItem).to_a.sample

		@item = @res["items"][@randomid]
		@tweet = "現在、Youtubeで以下の動画が話題になっているようです。\n[タイトル] #{@item["snippet"]["title"]}\n#{Constantlist::YOUTUBESHAREURL}/#{@item["snippet"]["resourceId"]["videoId"]}"

		@twitterClient.twieet(@tweet)
	end

	def companyCountTweet()

		#産業大分類コード
		array = []
		for num in "A".."T" do
		  array << num
		end
		@sicCode = array.sample


		#産業中分類コード
		@simcCodeResult = @reSasApi.getSimcCode(@sicCode)

		if @simcCodeResult["result"] != []
			@simcCode = @simcCodeResult["result"].sample["simcCode"]
		else
			@simcCode = "-"
		end

		#市区町村コード
		@cityCode = "-"

		#都道府県コード	
		@prefCode = (1..47).to_a.sample

		#リクエスト送信	
		@result = @reSasApi.getCompanyCount(@prefCode,@cityCode,@simcCode,@sicCode)

		
		if @result["result"] != nil && @result["result"]["data"] != []

			@data = @result["result"]["data"].sample
			@year = @data["year"]
			@count = @data["value"]

			@tweet = "お屋敷のデータベースを検索した結果、企業数は以下になっております。\n[産業大分類] #{@result["result"]["sicName"]}\n[産業中分類] #{@result["result"]["simcName"]}\n[都道府県] #{@result["result"]["prefName"]}\n[年] #{@year}\n[企業数] #{@count}"
			@twitterClient.twieet(@tweet)
		end
	end

	def wagesTweet()

		#産業大分類コード
		array = []
		for num in "A".."T" do
		  array << num
		end
		@sicCode = array.sample


		#産業中分類コード
		@simcCodeResult = @reSasApi.getSimcCode(@sicCode)

		if @simcCodeResult["result"] != []
			@simcCode = @simcCodeResult["result"].sample["simcCode"]
		else
			@simcCode = "-"
		end

		#年齢
		@wagesAge = (1..13).to_a.sample

		#都道府県コード	
		@prefCode = (1..47).to_a.sample

		#年	
		@year = (2010..2014).to_a.sample

		#リクエスト送信	
		@result = @reSasApi.getWages(@year,@prefCode,@sicCode,@simcCode,@wagesAge)



		if @result["result"] != nil

			@data = @result["result"]["data"].sample
			@year = @data["year"]
			@count = @data["value"]

			@tweet = ["お屋敷のデータベースを検索した結果、１人辺りの賃金は以下になっております。",
					"\n[産業大分類] #{@result["result"]["sicName"]}",
					"\n[産業中分類] #{@result["result"]["simcName"]}",
					"\n[都道府県] #{@result["result"]["prefName"]}",
					"\n[年] #{@year}",
					"\n[歳] #{ReSasApi::WAGESAGE[@wagesAge]}",
					"\n[年収] #{@count}万円"]

			@twitterClient.twieet(@tweet.join)
		end
	end

	def fgoTweet()

		@result = @rssApi.fgoSummaryApi()
		@target = @result["channel"][0]["item"].sample

		if @target["category"][0] == "イベント" || @target["category"][0] == "キャラクター" || @target["category"][0] == "ガチャ"
			@tweet = ["「Fate/Grand Order」について、以下の内容が話題になっているようです。",
					"\n[タイトル] #{@target["title"].to_s.delete("\"[]")}",
					"\n#{@target["link"].to_s.delete("\"[]")}"]

			@log.debug(@tweet.join);
			
			@twitterClient.twieet(@tweet.join);
		end
		
	end

	def nintendoTweet()

		@result = @rssApi.nintendoApi()	
		@target = @result["channel"][0]["item"].sample

		if @target["category"] != "その他" && DateTime.rfc2822(@target["pubDate"].join) >= Date.today
			@tweet = ["任天堂のHPに以下の内容が更新されたようです。",
					"\n[タイトル] #{@target["title"].to_s.delete("\"[]")}",
					"\n#{@target["link"].to_s.delete("\"[]")}"]
			@twitterClient.twieet(@tweet.join)
		end
	end

end

# UsuallyTweet.new.youtubeTweet()
# UsuallyTweet.new.companyCountTweet()
# UsuallyTweet.new.wagesTweet()
# UsuallyTweet.new.fgoTweet()
# puts UsuallyTweet.new.nintendoTweet()
