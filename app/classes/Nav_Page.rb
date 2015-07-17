class Nav_Page
	attr_accessor :page, :total_pages, :data 

	def initialize(data, page: 1,total_pages: 1)
		@data = data
		@page = page
		@total_pages = total_pages
	end

end