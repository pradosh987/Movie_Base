require 'net/http'
require 'json'


# REVIEW -- Even though API is an acronym, all caps is generally used for constants in Ruby. So this class should be called Api
class API
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'
	@@image_host ='https://image.tmdb.org/t/p/w185/'

	@@movie_info = 'movie/'
	@@genre = lambda {|id| 'genre/' + id + '/movies'}

	def self.prepare_query(query,append= '')
		# REVIEW -- it's generally a bad idea to treat URL construction as simply
		# concatenating strings. It's bound to break at some point or the other.
		# Use a URI library to construct a URL from its fragments. It will take
		# care of converting special characters into the URL-safe forms for you.
		return @@remote_api_end_point + query + '?api_key=' + @@api_key+ '&' + append
	end

	# REVIEW -- functions like this should be how your domain API is exposed to
	# your controller
	def self.fetch_movie(movie_id)
		call_api('movie/' + movie_id.to_s)
	end

	def self.call_api(params,apped_param ='', parse_func = nil)
		url = prepare_query(params,apped_param)
		#puts url
		resp = Net::HTTP.get_response(URI.parse(url))
		#puts resp.code
		begin		
			response = JSON.parse(resp.body)

			# REVIEW -- While this is technically correct, it's not the idiomatic
			# Ruby way. When dealing with only one lambda, Ruby tends to use blocks
			# & 'yield' to call them. They are functionall eqiuivalent to fn.call(),
			# but Ruby has syntatic sugar for a single block of code which is easier
			# to read. In fact, internally it is more optimized and efficient for
			# block & yield rather than lambda & call.

			# def self.call_api(params, append_param, &block)
			# 	response = yield(response) if block_given?
			# end

			# call_api do |resp|
			# 	# Do something with resp
			# end

	 		response = parse_func.call(response) if parse_func
	 		return response
	 	rescue
	 		# REVIEW -- Bad idea. Ignoring errors should NEVER be done. If this
	 		# current function does not know how to handle them, let them bubble
	 		# up. Else at some point you will be left scratching your head as to
	 		# why something is not working, when in fact a lower-level function is
	 		# catching & ignoring an error.
	 		return nil
	 	end
	end

	#def self.image_url_builder()
	#	return lambda {|x| @@image_host + x }
	#end



	@@list_parser = lambda do |source|
		return source['results']
	end
end

# REVIEW -- don't let stale code hang around. Delete ASAP. If you've committed
# often, you can get it back from Git history.
# movie_parser = lambda do |source|
# 	data = Hash.new
# 	data.push('backdrop_path',source['backdrop_path'])
# 	data.push('budget',source['budget'])
# end




#var = API.call_api('genre/878/movies',list_parser)#.each {|x| puts x}
#puts 'nil' if var == nil
#puts var

#https://api.themoviedb.org/3/movie/118340?api_key=b52469d21a984a24ec19edab6da3439e

