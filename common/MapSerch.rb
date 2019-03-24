require 'jp_prefecture'

class MapSerch

	def searchName(prefectures)
		return JpPrefecture::Prefecture.find name: prefectures
	end

end