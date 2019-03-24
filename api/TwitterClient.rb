require "twitter"
require 'logger'
require "./common/Constantlist.rb"


class TwitterClient

  attr_reader = :client

  def initialize()
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Constantlist::CONSUMER_KEY
      config.consumer_secret     = Constantlist::CONSUMER_SECRET 
      config.access_token        = Constantlist::ACCESS_TOKEN
      config.access_token_secret = Constantlist::ACCESS_TOKEN_SECRET 
    end

    @log = Logger.new(STDOUT)

  end

  def twieet(str)
    @log.debug("文字数：　#{str.length}")
    @client.update(str)
  end

  # 自分のプロフィールを表示
  def show_my_profile
    # @log.debug("#{@client.user.screen_name}")   # アカウントID
    # @log.debug("#{@client.user.name}")          # アカウント名
    # @log.debug("#{@client.user.description}")   # プロフィール
    # @log.debug("#{@client.user.tweets_count}")  # ツイート数
    return @client
  end

  # 指定したアカウントのプロフィールを表示
  def show_user_profile(user_name)
    puts @client.user(user_name).screen_name  #アカウントID
    puts @client.user(user_name).name         # アカウント名
    puts @client.user(user_name).description  # プロフィール
    puts @client.user(user_name).tweets_count # ツイート数
  end

  # タイムラインの表示
  def show_timeline
    @client.home_timeline.each do |tweet|
      puts tweet.full_text
      puts "FAVORITE: #{tweet.favorite_count}"
      puts "RETWEET : #{tweet.retweet_count}"
      puts "CREATED : #{tweet.created_at}"
    end
  end

  # リプライ一覧を取得
  def show_comment
    @client.mentions_timeline.each do |tweet|
      puts tweet.full_text
      puts "FAVORITE: #{tweet.favorite_count}"
      puts "RETWEET : #{tweet.retweet_count}"
      puts "CREATED : #{tweet.created_at}"
      puts tweet.entities？
    end
  end

  # 指定数の最新のツイートを表示
  def show_recently_twieet(user_name, twieet_count)
    @client.user_timeline(user_name, { count: twieet_count } ).each do |timeline|
      tweet = @client.status(timeline.id)
      puts tweet.created_at
      puts tweet.text
    end
  end

  # 指定ワードを検索。param:countは件数
  def search(word, count)
    @client.search(word).take(count).each do |tweet|
      tweet
    end
  end

  # フォロワー数は取得    
  def followers_count(name)
    puts @client.user(name).followers_count
  end

  def trends(id = 1118370)
    return @client.trends(id).to_h
  end

end


