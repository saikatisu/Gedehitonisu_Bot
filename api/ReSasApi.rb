require 'logger'
require 'json'
require './common/RestHttp.rb'
require './common/Constantlist.rb'

class ReSasApi

	RESASURL = "https://opendata.resas-portal.go.jp"
	WAGE = "/api/v1/municipality/wages/perYear"
	BROAD = "/api/v1/industries/broad"
	MIDLE = "/api/v1/industries/middle"
	COMPANY = "/api/v1/municipality/company/perYear"
	HEAD = {"X-API-KEY"=>"#{Constantlist::RESASAPI}"}
	WAGESAGE = {1=>"総数",
				2=>"~ 19歳",
				3=>"20～24歳",
				4=>"25～29歳",
				5=>"30～34歳",
				6=>"35～39歳",
				7=>"40～44歳",
				8=>"45～49歳",
				9=>"50～54歳",
				10=>"55～59歳",
				11=>"60～64歳",
				12=>"65～69歳",
				13=>"70歳～"}


	def initialize()
		@restHttp = RestHttp.new
		@log = Logger.new(STDOUT)
	end

	def getWages(year=2014,prefCode=13,sicCode="-",simcCode="-",wagesAge=3)

		@log.debug("一人当たり賃金")
		@param = "?year=#{year}&prefCode=#{prefCode}&sicCode=#{sicCode}&simcCode=#{simcCode}&wagesAge=#{wagesAge}"
		@result = @restHttp.GetRequest("#{ReSasApi::RESASURL}#{ReSasApi::WAGE}",@param, ReSasApi::HEAD)
		return JSON.parse(@result)
	end

	def getSicCode()

		@log.debug("産業大分類一覧")
		@result = @restHttp.GetRequest("#{ReSasApi::RESASURL}#{ReSasApi::BROAD}", "", ReSasApi::HEAD)

		return JSON.parse(@result)
	end

	def getSimcCode(sicCode="")

		@log.debug("産業中分類一覧")
		@result = @restHttp.GetRequest("#{ReSasApi::RESASURL}#{ReSasApi::MIDLE}", "?sicCode=#{sicCode}", ReSasApi::HEAD)

		return JSON.parse(@result)
	end

	def getCompanyCount(prefCode=13,cityCode="-",simcCode=39,sicCode="G")

		@log.debug("企業数")
		@param = "?prefCode=#{prefCode}&cityCode=#{cityCode}&simcCode=#{simcCode}&sicCode=#{sicCode}"
		@result = @restHttp.GetRequest("#{ReSasApi::RESASURL}#{ReSasApi::COMPANY}", @param	, ReSasApi::HEAD)

		return JSON.parse(@result)
	end
end

# puts ReSasApi.new.getSicCode()["result"]
# puts ReSasApi.new.getSimcCode("R")["result"]
# puts ReSasApi.new.getCompanyCount()["result"]["simcName"]

