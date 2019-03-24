require 'net/http'
require 'logger'
require './common/ErrorUtility'
require './api/TwitterClient'

class RestHttp

	def initialize()
		@log = Logger.new(STDOUT)
		@twitterClient = TwitterClient.new
	end

	def httpsend(apiUrl , param="", head=nil)

		begin

			request_uri = apiUrl + param
			@log.debug("リクエストurl：#{request_uri }")
			url = URI.parse(request_uri)

			request = Net::HTTP.new(url.host, url.port)

			if request_uri =~ /^https/
				request.use_ssl=true
			end

			if head != nil
				head.each do |key,value|
					# request[key] = value
				end
			end

			res = request.start {
			  request.get(url.request_uri)
			}

			@log.debug("リクエストを送信しました")

			if res.code == '200'
				return res

			else
				@log.debug("リクエストに失敗しました")
				return res
			end

		rescue Exception => e
			@log.debug("エラー")
			@log.debug(e.message)
			ErrorUtility.eroorRecode(e)
			# @twitterClient.tweet(ErrorUtility.getCode())

		end
	end

	def GetRequest(apiUrl,param="",head=nil)

		begin
			if apiUrl != nil
				ssl = false
				request_uri = apiUrl + param
				@log.debug(request_uri)
				uri = URI.parse(request_uri)
				req = Net::HTTP::Get.new(uri) 

				if head != nil
					head.each do |key,value|
						req["#{key}"]="#{value}"
					end
				end

				if request_uri =~ /^https/
					ssl=true
				end

				res = Net::HTTP.start(uri.host, uri.port,:use_ssl=>ssl) do |http|
				  http.request(req)
				end

				return res.body
			else
				raise

			end
		rescue Exception => e
			@log.debug("エラー")
			@log.debug(e.message)
			ErrorUtility.eroorRecode(e)

		end
	end

end
