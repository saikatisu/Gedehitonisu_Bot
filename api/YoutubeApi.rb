require 'logger'
require 'json'
require './api/TwitterClient'
require './common/RestHttp.rb'
require './common/ReadXml.rb'
require './common/Constantlist.rb'

class YoutubeApi

	CHENNELLIST = {"人気_日本" =>"UCMlwQuZJJQppHO6-FkGgiqQ"}
	APILIST = {"検索"=>"search","再生リスト"=>"playlistItems"}
	PLAYVIDEOLIST = {"今人気の動画"=>"PLuXL6NS58Dyztg3TS-kJVp58ziTo5Eeck&key=AIzaSyAxCGQJuT0rcONUvCynarpmx1ZMS9MeN3M"}

	def initialize()
		@restHttp = RestHttp.new
		@log = Logger.new(STDOUT)
		@readXml = ReadXml.new 
	end

	def channelDtail()

	end

	def videolList(part="snippet",playlistId,maxResults)

		@log.debug("再生項目：#{playlistId}")
		@method = YoutubeApi::APILIST["再生リスト"]
		@param = "/#{@method}?part=snippet&playlistId=#{playlistId}&maxResults=#{maxResults}&key=#{Constantlist::YOUTUBEAPIKEY}"
		@log.debug("パラメータ：#{@param}")

		@result = @restHttp.httpsend(Constantlist::YOUTUBEURL, @param)

		return JSON.parse(@result.body)

	end

end
