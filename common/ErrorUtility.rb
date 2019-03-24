require 'logger'

class ErrorUtility
	@@errorCode

	def self.eroorRecode(e)

		@log = Logger.new(STDOUT)
		@log.debug("クラス：#{e.class}")
		@log.debug("エラーメッセージ：#{e.message}")
		@log.debug(e.backtrace.join("\n"))
		@@errorCode = "#{e.message}"

	end

	def self.getCode()
		reutrn @@errorCode
	end
end