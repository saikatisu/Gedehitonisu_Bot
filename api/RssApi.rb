require 'logger'
require 'json'
require './common/RestHttp.rb'
require './common/Constantlist.rb'
require './common/ReadXml.rb'



class RssApi

	TOPIC = {"ir"=>"ピックアップ","y"=>"社会","w"=>"国際","b"=>"ビジネス","p"=>"政治","e"=>"エンタメ","s"=>"スポーツ","t"=>"テクノロジー","po"=>"話題のニュース"}
	GOOGLENEWS = "http://news.google.com/news"
	FGOWIKI = "https://www9.atwiki.jp/f_go/rss10_new.xml"
	FGOSAMMARY = "https://xn--fgo-gh8fn72e.com/feed"
	NINTENDORSS = "https://www.nintendo.co.jp/news/whatsnew.xml" 


	def initialize()
		@restHttp = RestHttp.new
		@log = Logger.new(STDOUT)
		@readxml = ReadXml.new
	end

	def googleNewsApi(hl="ja",ned="us",ie="UTF-8",oe="UTF-8",output="rss",topic="ir")
		@log.debug("GoogleNews取得")
		param = "?hl=#{hl}&ned=#{ned}&ie=#{ie}&oe=#{oe}&output=#{output}&topic=#{topic}"
		@log.debug("パラメータ：#{param}")
		result = @restHttp.GetRequest(RssApi::GOOGLENEWS , param , nil)
		return result
	end

	def fgoWikiApi()
		@log.debug("FGO_WIKI取得")
		result = @restHttp.GetRequest(RssApi::FGOWIKI)
		chResult = @readxml.changeHash(result,false)
		return chResult
	end

	def fgoSummaryApi()
		@log.debug("FGO_Summary取得")
		result = @restHttp.GetRequest(RssApi::FGOSAMMARY)
		chResult = @readxml.changeHash(result,false)
		return chResult
	end

	def nintendoApi()
		@log.debug("任天堂情報取得")
		result = @restHttp.GetRequest(RssApi::NINTENDORSS)
		chResult = @readxml.changeHash(result,false)
		return chResult
	end



end

# puts RssApi.new.fgoWikiApi()["item"][0]["title"]