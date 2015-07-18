require 'net/http'
require 'json'
load 'app/classes/Profile.rb'
load 'app/classes/Movie.rb'
load 'app/classes/Review.rb'
load 'app/classes/Nav_Page.rb'
require 'uri'


class Remote_Api
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'
	@@image_host ='https://image.tmdb.org/t/p/w185/'


	def self.prepare_query(query,append ='')
		return URI.encode(@@remote_api_end_point + query + '?api_key=' + @@api_key+ '&' + append)
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
		image_host_1 = 'https://image.tmdb.org/t/p/w'
		case type
		when 'x-small'
			return URI.encode(image_host_1 + '92' + image.to_s)
		when 'small'
			return URI.encode(image_host_1 + '185' + image.to_s)
		when 'medium'
			return URI.encode(image_host_1 + '185' + image.to_s)
		when 'large'
			return URI.encode(image_host_1 + '780' + image.to_s)
		when 'small-wide'
			return URI.encode(image_host_1 + '185' + image.to_s)
		when 'medium-wide'
			return URI.encode(image_host_1 + '185' + image.to_s)
		when 'large-wide'
			return URI.encode(image_host_1 + '185' + image.to_s)
		else
			return URI.encode('https://d3a8mw37cqal2z.cloudfront.net/assets/f996aa2014d2ffddfda8463c479898a3/images/no-poster-w185.jpg')
		end
	end

	def self.make_movie_list(raw_data)
		movies = Array.new 

		raw_data['results'].each do |movie|
			name = movie['original_title']
			id = movie['id']
			poster = get_image_url('small', movie['poster_path'])
			backdrop = get_image_url('large', raw_data["backdrop_path"])
			overview = movie['overview']
			m = Movie.new(name, id, {'poster' => poster, 'overview' => overview})
			movies.push(m)
		end
		return movies
	end

	#Remote API endpoint methods
	def self.get_now_playing_movies(list = false)
		raw_data = call_api('movie/now_playing')

		movies = make_movie_list(raw_data)
		return movies if list==true
		
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end
	
	def self.get_upcoming_movies(list = false)
		raw_data = call_api('movie/upcoming')
		movies = make_movie_list(raw_data)
		return movies if list==true
		return Nav_Page.new(movies,raw_data['page'],raw_data['total_pages'])
	end

	def self.get_popular_movies(list = false)
		return call_api('movie/popular') if list==true
		raw_data = call_api('movie/popular')
		return Nav_Page.new(make_movie_list(raw_data),raw_data['page'],raw_data['total_pages'])
	end

	def self.get_similar_movies(id, flag = false)
	 	raw_data = call_api('movie/' + id.to_s + '/similar')
	 	return raw_data if flag==true
	 	return make_movie_list(raw_data)
	end

	def self.get_movie_details(id, flag = false)
		raw_data = call_api('movie/' + id.to_s)
		return raw_data if flag==false
		title = raw_data['original_title']
		id = raw_data['id']

		opts = Hash.new
		opts['overview'] = raw_data['overview']
		opts['backdrop'] = get_image_url('large', raw_data["backdrop_path"])
		opts['poster'] = get_image_url('large', raw_data["poster_path"])
		opts['budget'] = raw_data["budget"]
		opts['homepage'] = raw_data["homepage"]
		opts['language'] = raw_data["original_language"]
		opts['production_companies'] = raw_data["production_companies"]
		opts['release_date'] = raw_data["release_date"]
		opts['runtime'] = raw_data["runtime"]
		opts['tagline'] = raw_data["tagline"]
		opts['ratings'] = raw_data["vote_average"]
		opts['cast'] = get_cast_from_movie(id)
		opts['similar_movies'] = get_similar_movies(id)
		opts['reviews'] = get_reviews_of_movie(id)

		puts opts['reviews'].inspect
		return Movie.new(title,id,opts)
	end

	def self.get_cast_from_movie(id, flag = false)
		raw_data = call_api('movie/' + id.to_s + '/credits')
		return raw_data if flag==true
		profiles = Array.new
		raw_data['cast'].each do |cast|
			name = cast['name']
			id = cast['id']
			picture = get_image_url('x-small',cast["profile_path"])
			pro = Profile.new(name,id,{'profile_picture' => picture})
			profiles.push(pro)
		end
		return profiles
	end

	def self.get_reviews_of_movie(id)
		raw_data = call_api('movie/' + id.to_s + '/reviews')
		#return raw_data if flag==true
		reviews = Array.new
		raw_data['results'].each do |rev|
			id = rev['id']
			content = rev['content']
			reviews.push(Review.new(id,content))
		end
		return reviews
	end

	def self.get_movies_by_genre(id, list = false)
		raw_data = call_api('genre/'+id+'/movies')
		return raw_data if list==true
		return Nav_Page.new(make_movie_list(raw_data),raw_data['page'],raw_data['total_pages'])
	end

	def self.get_movies_by_company(id, list = false)
		raw_data =  call_api('company/'+ id +'/movies')
		return raw_data if list==true
		return Nav_Page.new(make_movie_list(raw_data),raw_data['page'],raw_data['total_pages'])
	end

	def self.get_movies_starred_by(id)
		raw_data = call_api('person/' + id.to_s + '/movie_credits')
		puts raw_data.inspect 
		return Nav_Page.new(make_movie_list(raw_data),raw_data['page'],raw_data['total_pages'])
	end

	def self.get_profile(id)
	 raw_data = call_api('person/' + id.to_s)
	 id = raw_data['id']
	 name = raw_data['name']
	 opts = Hash.new
	 opts['place_of_birth'] = raw_data['place_of_birth']
	 opts['biography'] = raw_data['biography']
	 opts['profile_picture'] = get_image_url('medium-wide',raw_data['profile_path'])
	 opts['homepage'] = raw_data['homepage']
	 #opts['starred_in'] = get_movies_starred_by(id)
	 pro = Profile.new(id,name,opts)
	 return pro
	end

	def self.search(keyword, list=false)
		raw_data =  call_api('search/movie','query=' + keyword)
		return raw_data if list==true
		return Nav_Page.new(make_movie_list(raw_data),raw_data['page'],raw_data['total_pages'])
	end

end
