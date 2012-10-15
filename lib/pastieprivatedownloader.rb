require 'mechanize'

class PastiePrivateDownloader < PasteDownloader
	register_downloader :pastieprivate
	
	def initialize
		@@file_suffix = "pastieprivate"
	end
	
	def download unique_id
		agent = Mechanize.new
		agent.user_agent_alias = "Windows Mozilla"
		page = agent.get("http://pastie.org/private/#{unique_id}")
		download_link = page.links_with(:text => 'Download')[0].click
		save_file unique_id, download_link.body
	end
end
