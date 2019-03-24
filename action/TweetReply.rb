require "twitter"
require 'logger'
require "./common/MapSerch.rb"
require './api/YahooApi.rb'
require './common/Constantlist.rb'
require './common/ReadXml.rb'
require './api/TwitterClient.rb'

class TweetReply

	def initialize()
		@log = Logger.new(STDOUT)
		@mapSerch = MapSerch.new
		@yahooApi = YahooApi.new
		@readXml = ReadXml.new
		@twitterClient = TwitterClient.new
	end

	def replyDecision(object)

		#降水情報に関するツイートかを判定
		# if /\[降水量\]:\[.{1,3}[都道府県]\]/ === object.text
		if  object.text.match(/.{1,3}[都道府県].*天気/).nil?
			unknownResponse(object)
		else
			weatherResponse(object)
		end

	end


	def weatherResponse(object)

		str = nil
		JpPrefecture::Prefecture.all.each { |prefectures|

			if(object.text.match(/#{prefectures.name}/))
				str = prefectures.name
			end

		}

		# prefectures = object.text.slice(/\[.{1,3}[都道府県]\]/).delete("[]")
		# @log.debug("都道府県：#{prefectures}")
		# mapCode = @mapSerch.searchName(prefectures)
		mapCode = @mapSerch.searchName(str)
		@log.debug(mapCode.code)
		resMap = @yahooApi.mapApi(mapCode.code)

		resweather = @yahooApi.weatherApi(resMap["Feature"][0]["Property"]["Station"][0]["Geometry"]["Coordinates"]) 
		weatherList = @readXml.changeHash(resweather)
		reply = "\n [場所]　#{str}"
		reply << "\n #{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[2..5]}年#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[6..7]}月#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[8..9]}日#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[10..11]}時#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[12..13]}分　: 降水強度（単位：mm/h） #{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Rainfall"].to_s[2..5]} "
		@log.debug("#{reply.length}")
		if weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Rainfall"].to_s[2..5] == "0.00"
			reply.insert(0,"@#{object.user.screen_name}　\n 現在、雨は降っていません。\n 以下が降水量の情報になります。")
		else
			reply.insert(0,"@#{object.user.screen_name}　\n 現在、雨が降っています。\n お出かけの際には傘をお持ちください。\n 以下が降水量の情報になります。")
		end
		@log.debug("#{reply.length}")

		@twitterClient.twieet(reply)		
	end


	def weatherResponsetext(object)

		@log.debug("都道府県：#{object}")
		mapCode = @mapSerch.searchName(object)
		@log.debug(mapCode.code)
		resMap = @yahooApi.mapApi(mapCode.code)

		resweather = @yahooApi.weatherApi(resMap["Feature"][0]["Property"]["Station"][0]["Geometry"]["Coordinates"]) 
		weatherList = @readXml.changeHash(resweather)
		reply = "\n [場所]　#{object}"
		reply << "\n #{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[2..5]}年#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[6..7]}月#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[8..9]}日#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[10..11]}時#{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Date"].to_s[12..13]}分　: 降水強度（単位：mm/h） #{weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Rainfall"].to_s[2..5]} "
		@log.debug("#{reply.length}")
		if weatherList["Feature"][0]["Property"][0]["WeatherList"][0]["Weather"][0]["Rainfall"].to_s[2..5] == "0.00"
			reply.insert(0,"現在、雨は降っていません。\n 以下が降水量の情報になります。")
		else
			reply.insert(0,"現在、雨が降っています。\n お出かけの際には傘をお持ちください。\n 以下が降水量の情報になります。")
		end
		@log.debug("#{reply.length}")

		@twitterClient.twieet(reply)		
	end

	def unknownResponse(object)
		@tweet = "@#{object.user.screen_name} 人類の言語はまだ学習中です。ご期待に添えず、申し訳ございません。"
		@twitterClient.twieet(@tweet);
	end

	def threndsResponse()

		nowtrends = @twitterClient.trends()

		return nowtrends[:trends].sample[:name]
	end
end
