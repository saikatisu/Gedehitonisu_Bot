require 'logger'
require './common/RestHttp.rb'
require './common/ReadXml.rb'
require './common/Constantlist.rb'


class NicoVideoApi

	TARGETLIST = {"view" => "再生数","res"=>"コメント","mylist"=>"マイリスト"}
	PERIODLIST = {"hourly"=>"毎時","daily"=>"24時間","weekly"=>"週間","monthly"=>"月間","total"=>"合計"}
	CATEGORYLIST = {"all"=>"合算","music"=>"音楽","draw"=>"描いてみた","ent"=>"エンターテイメント","anime"=>"アニメ",
		"game"=>"ゲーム","animal"=>"動物","radio"=>"ラジオ","sport"=>"スポーツ","politics"=>"政治","science"=>"科学",
		"history"=>"歴史","cooking"=>"料理","nature"=>"自然","drive"=>"車載動画","are"=>"例のアレ","toho"=>"東方",
		"imas"=>"アイドルマスター","jikkyo"=>"実況プレイ動画","travel"=>"旅行","make"=>"作ってみた","handcraft"=>"ニコニコ手芸部",
		"tech"=>"ニコニコ科学班部","diary"=>"日記","dance"=>"踊ってみた","sing"=>"歌ってみた","play"=>"やってみた",
		"lecture"=>"ニコニコ動画講座","other"=>"その他","r18"=>"18禁"}

	def initialize()
		@restHttp = RestHttp.new
		@log = Logger.new(STDOUT)
		@readXml = ReadXml.new 
	end

	def getRanking(target="view", period="hourly", category="all")

		@log.debug("対象：#{target}")
		@log.debug("期間：#{period}")
		@log.debug("カテゴリ：#{category}")

		param = "/#{target}/#{period}/#{category}?rss=2.0"
		@log.debug("パラメータ：#{param}")
		result = @readXml.changeHash(@restHttp.httpsend(Constantlist::NICOVIDEOURL, param))
		return result
	end

	def getDitailVideo(videoId)

		@log.debug("動画ID：#{videoId}")
		param = "/#{videoId}"
		@log.debug("パラメータ：#{param}")
		result = @readXml.changeHash(@restHttp.httpsend(Constantlist::NICOVIDEDETAILOURL, param))

		return result
	end

end

# puts NicoVideoApi.new.getRanking["channel"][0]["item"]
# puts NicoVideoApi.new.getDitailVideo("sm15498462")