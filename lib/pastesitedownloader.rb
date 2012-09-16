require 'mechanize'

class PastesiteDownloader < PasteDownloader
	register_downloader :pastesite
	
	def initialize
		@@file_suffix = "pastesite"
	end
	
	def download unique_id
		agent = Mechanize.new
		agent.user_agent_alias = "Windows Mozilla"
		goodies = agent.get("http://pastesite.com/plain/#{unique_id}")
		continue = goodies.forms[0]
		confirm = agent.submit(continue)
		save_file unique_id, confirm.body
	end
end