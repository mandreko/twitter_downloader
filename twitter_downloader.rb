#!/usr/bin/ruby
require 'rubygems'
require 're'
require 'url_expander'
require 'twitter'
require 'sqlite3'
require_relative './lib/pastedownloader'

# Twitter.configure do |config|
#   config.consumer_key = ""
#   config.consumer_secret = ""
#   config.oauth_token = ""
#   config.oauth_token_secret = ""
# end

# Load the database of twitter ids that have been downloaded
db = SQLite3::Database.new("passfile.db")
# Create schema if it doesn't exist
db.execute "CREATE TABLE IF NOT EXISTS tweets (id INTEGER PRIMARY KEY);"

page = 0
begin
	tweets = Twitter.user_timeline("passfile", :page => page, :count => 200)
	break if tweets.count == 0  # Once we've ran out of tweets, go ahead and exit
	
	puts "Tweets in this batch: #{tweets.count}"
	puts "Tweet rate limit remaining: #{Twitter.rate_limit.remaining}"
	
	tweets.each_with_index do |tweet, idx|
		next if tweet.text !~ /(http.*t.co.*\/[a-zA-Z0-9]+) .*$/ # If it's not a url, skip it
		
		# If the tweet is found to have already been downloaded, skip it
		next if !db.get_first_row( "select id from tweets where id = ?", tweet.id).nil?
		
		begin
			url = UrlExpander::Client.expand($1)
			puts "Processing #{url}"
			
			case url
				when /http.*pastebin.*\/(.*)/
					downloader = PasteDownloader.create(:pastebin)
				when /http.*paste2.*\/p\/(.*)/
					downloader = PasteDownloader.create(:paste2)
				when /http.*pastesite.*\/(.*)/
					downloader = PasteDownloader.create(:pastesite)
				when /http.*pastedump.*\/paste\/(.*)/
					downloader = PasteDownloader.create(:pastedump)
				when /http.*nopaste.*\/(.*)/
					downloader = PasteDownloader.create(:nopaste)
				else
					raise "No downloader available for URL: #{url}"
			end

			goodies = downloader.download($1)
			
			# If download was successful, then insert the tweet id into the database so we never try to download it again
			db.execute("INSERT INTO tweets(id) VALUES ('#{tweet.id}')")

		rescue Exception => e
			puts "ERROR: #{e}"
			next # Eat the error
		end
	end

	page += 1
end while tweets.count > 0
