class Review

	attr_accessor :id, :movie_title, :author, :content

	def initialize(id, content, author = 'N/A', movie_title: 'N/A')
		@id = id
		@content = content
		@author = author
		@movie_title = movie_title
	end
end