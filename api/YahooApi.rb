require 'logger'
require 'json'
require './common/RestHttp.rb'
require './common/Constantlist.rb'


class YahooApi

	def initialize()
		@restHttp = RestHttp.new
		@log = Logger.new(STDOUT)
	end

	def weatherApi(coordinates)
		@log.debug("緯度経度：#{coordinates}")
		param = "?coordinates=#{coordinates}&appid=#{Constantlist::APPID}"
		@log.debug("パラメータ：#{param}")
		result = @restHttp.httpsend(Constantlist::WEATHERAPI , param)
		return result
	end

	def mapApi(mapCode)
		@log.debug("都道府県コード：#{mapCode}")
		param = "?ac=#{mapCode}&output=json&appid=#{Constantlist::APPID}"
		@log.debug("パラメータ：#{param}")
		res = @restHttp.httpsend(Constantlist::MAPAPI , param)
		result = JSON.parse(res.body)
		return result
	end

end