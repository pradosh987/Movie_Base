class Review

	attr_accessor :id, :movie_id, :movie_title, :author_id, :content

	def initialize(id, content, author_id: 'N/A', movie_title: 'N/A')
		@id = id
		@movie_id = movie_id
		@content = content
		@author_id = author_id
		@movie_title = movie_title
	end
end