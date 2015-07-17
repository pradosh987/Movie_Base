require 'net/http'
require 'json'



class API
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'
	@@image_host ='https://image.tmdb.org/t/p/w185/'

	@@movie_info = 'movie/'
	@@genre = lambda {|id| 'genre/' + id + '/movies'}

	def self.prepare_query(query,append= '')
		return @@remote_api_end_point + query + '?api_key=' + @@api_key+ '&' + append
	end

	def self.call_api(params,apped_param ='', parse_func = nil)
		url = prepare_query(params,apped_param)
		#puts url
		resp = Net::HTTP.get_response(URI.parse(url))
		#puts resp.code
		begin		
			response = JSON.parse(resp.body)
	 		response = parse_func.call(response) if parse_func
	 		return response
	 	rescue
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

movie_parser = lambda do |source|
	data = Hash.new
	data.push('backdrop_path',source['backdrop_path'])
	data.push('budget',source['budget'])
end




#var = API.call_api('genre/878/movies',list_parser)#.each {|x| puts x}
#puts 'nil' if var == nil
#puts var

#https://api.themoviedb.org/3/movie/118340?api_key=b52469d21a984a24ec19edab6da3439e

