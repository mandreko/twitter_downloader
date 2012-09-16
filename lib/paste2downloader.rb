require 'open-uri'

class Paste2Downloader < PasteDownloader
	register_downloader :paste2
	
	def initialize
		@@file_suffix = "paste2"
	end
	
	def download unique_id
		save_file unique_id, open("http://paste2.org/get/#{unique_id}").read
	end
end