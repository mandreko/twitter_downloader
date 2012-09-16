require 'open-uri'

class PastedumpDownloader < PasteDownloader
	register_downloader :pastedump
	
	def initialize
		@@file_suffix = "pastedump"
	end
	
	def download unique_id
		save_file unique_id, open("http://www.pastedump.com/raw/#{unique_id}").read # be sure to use 'www' for this site
	end
end