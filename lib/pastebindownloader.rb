require 'open-uri'

class PastebinDownloader < PasteDownloader
	register_downloader :pastebin
	
	def initialize
		@@file_suffix = "pastebin"
	end
	
	def download unique_id
		save_file unique_id, open("http://pastebin.com/raw.php?i=#{unique_id}").read
	end
end