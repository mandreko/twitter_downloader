require 'open-uri'

class NoPasteDownloader < PasteDownloader
	register_downloader :nopaste
	
	def initialize
		@@file_suffix = "nopaste"
	end
	
	def download unique_id
		save_file unique_id, open("http://nopaste.me/raw/#{unique_id}.txt").read # be sure to use 'www' for this site
	end
end