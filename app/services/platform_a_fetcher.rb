module FetchPlatforms
  class PlatformAFetcher
  	def initialize
  		VenuePlatform.find_or_create(platform_name='platform_a')
  	end
  end
end