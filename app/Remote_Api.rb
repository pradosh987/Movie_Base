require 'net/http'
require 'json'
load 'app/classes/Profile.rb'
load 'app/classes/Movie.rb'
load 'app/classes/Review.rb'
load 'app/classes/Nav_Page.rb'


class Remote_Api
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'
	@@image_host ='https://image.tmdb.org/t/p/w185/'


	def self.prepare_query(query,append ='')
		return @@remote_api_end_point + query + '?api_key=' + @@api_key+ '&' + append
	end

	def self.call_api(params,apped_param ='', parse_func = nil)
		url = prepare_query(params,apped_param)
		resp = Net::HTTP.get_response(URI.parse(url))
		begin		
			response = JSON.parse(resp.body)
	 		response = parse_func.call(response) if parse_func
	 		return response
	 	rescue
	 		return nil
	 	end
	end


	#Remote API endpoint methods
	def self.get_now_playing_movies()
		call_api('movie/now_playing')
	end

	def self.get_now_playing_movies_new()
		raw_data = call_api('movie/now_playing')

		movies = Array.new 

		raw_data['results'].each do |movie|
			name = movie['original_title']
			id = movie['id']
			poster = 'https://image.tmdb.org/t/p/w185' + movie['poster_path'] if movie['poster_path']
			overview = movie['overview']
			m = Movie.new(name, id, {'poster' => poster, 'overview' => overview})
			movies.push(m)
		end
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end
	
	def self.get_upcoming_movies()
		call_api('movie/upcoming')
	end

	def self.get_popular_movies()
		call_api('movie/popular')
	end

	def self.get_similar_movies(id)
	 	call_api('movie/' + id.to_s + '/similar')
	end

	def self.get_movie_details(id)
		call_api('movie/' + id.to_s)
	end

	def self.get_cast_from_movie(id)
		call_api('movie/' + id.to_s + '/credits')
	end

	def self.get_reviews_of_movie(id)
		call_api('movie/' + id.to_s + '/reviews')
	end

	def self.get_movies_by_genre(id)
		call_api('genre/'+id+'/movies')
	end

	def self.get_movies_by_company(id)
		call_api('company/'+ id +'/movies')
	end

	def self.get_movies_starred_by(id)
		call_api('person/' + id.to_s + '/movie_credits')
	end

	def self.get_profile(id)
		call_api('person/' + id.to_s)
	end

	def self.search(keyword)
		call_api('search/movie','query=' + keyword)
	end

end
