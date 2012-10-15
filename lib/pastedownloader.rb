class PasteDownloader
	@@subclasses = { }
	
	#TODO: Is there a way to calculate this based on the subclass, similar to .class.name?
	@@file_suffix = ""
	
	def self.create type
		c = @@subclasses[type]
		if c
			c.new
		else
			raise "Bad log file type: #{type}"
		end
	end
	
	def self.register_downloader name
		@@subclasses[name] = self
	end
	
	def save_file unique_id, output
		file = open("#{unique_id}_#{@@file_suffix}.txt", "w")
		file.write(output)
		file.close
	end
end



# Include all sub-classes
require_relative './paste2downloader'
require_relative './pastebindownloader'
require_relative './pastedumpdownloader'
require_relative './pastesitedownloader'
require_relative './nopastedownloader'
require_relative './pastieprivatedownloader'
