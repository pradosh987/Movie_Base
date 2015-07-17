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

	def self.get_image_url(type, image)
		case type
		when 'small'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		when 'medium'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		when 'large'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		when 'small-wide'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		when 'medium-wide'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		when 'large-wide'
			return 'https://image.tmdb.org/t/p/w185' + image.to_s
		else
			return 'https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg'
		end
	end

	def self.make_movie_list(raw_data)
		movies = Array.new 

		raw_data['results'].each do |movie|
			name = movie['original_title']
			id = movie['id']
			poster = get_image_url('small', movie['poster_path'])
			overview = movie['overview']
			m = Movie.new(name, id, {'poster' => poster, 'overview' => overview})
			movies.push(m)
		end
		return movies
	end

	#Remote API endpoint methods
	def self.get_now_playing_movies(list = false)
		raw_data = call_api('movie/now_playing')
		return raw_data if list==true
		movies = make_movie_list(raw_data)
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end
	
	def self.get_upcoming_movies(list = false)
		raw_data = call_api('movie/upcoming')
		return raw_data if list==true
		movies = make_movie_list(raw_data)
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end

	def self.get_popular_movies(list = false)
		return call_api('movie/popular') if list==true
		raw_data = call_api('movie/popular')
		movies = make_movie_list(raw_data)
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
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

	def self.search(keyword, list=false)
		raw_data =  call_api('search/movie','query=' + keyword)
		return raw_data if list==true
			movies = make_movie_list(raw_data)
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end

end
