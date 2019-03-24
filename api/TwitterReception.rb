require 'tweetstream'
require './common/Constantlist.rb'
require './action/TweetReply.rb'
require 'logger'
require './api/TwitterClient.rb'

class TwitterReception

  def initialize()

    #クライアント設定
    TweetStream.configure do |config|
      config.consumer_key        = Constantlist::CONSUMER_KEY
      config.consumer_secret     = Constantlist::CONSUMER_SECRET 
      config.oauth_token         = Constantlist::ACCESS_TOKEN
      config.oauth_token_secret  = Constantlist::ACCESS_TOKEN_SECRET 
      config.auth_method        = :oauth
    end

    @notification = TweetStream::Client.new
    @tweetReply = TweetReply.new
    @twitterClient = TwitterClient.new
    @log = Logger.new(STDOUT)

    #Twitter通知待ち受け設定
    self.setting

  end

  def setting

    # 稼働時の処理（ここではサーバ接続したことを表示）
    @notification.on_inited do
      @log.debug('Connected...')
    end

    #接続時に送られるフォロワーリストを受けたときの処理
    @notification.on_friends do |friends|
      @log.debug('recieve a friends list')
    end

    #ツイート削除を含むメッセージを受けたときの処理
    @notification.on_delete do |status_id, user_id|
      @log.debug("recieve a delete message / status_id: #{status_id}, user_id: #{user_id}")
    end

    #ツイートなどを含むメッセージを受けたときの処理
    @notification.on_timeline_status do |status|
      @log.debug('recieve a TL status')
    end

    @notification.on_direct_message do |direct_message|
      @log.debug("direct message")
      @log.debug("#{direct_message.text}")
    end

    #その他のメッセージを受けたときの処理も同様に
    #client.on… do |object|
    #  do something
    #end

    #on設定を終えたあとにclient.userstreamメソッドを稼働させる
    @notification.userstream do |object|

      @log.debug("recieve a tweet / class: #{object.class}")
      @log.debug(object.text) 

      #リプライされた場合
      if object.in_reply_to_screen_name == @twitterClient.show_my_profile.user.screen_name
        @tweetReply.replyDecision(object)
      end
    end
  end
end
