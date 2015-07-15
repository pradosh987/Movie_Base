require 'net/http'
require 'json'

class API
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'

	def self.prepare_query(query)
		return @@remote_api_end_point + query + '?api_key=' + @@api_key
	end

	def self.call_api(params,parse_func = nil)
		url = prepare_query(params)
		resp = Net::HTTP.get_response(URI.parse(url))
		return nil if  resp.code.to_s != 200.to_s
		response = JSON.parse(resp.body)
	 	response = parse_func.call(response) if parse_func
	 	return response
	end
end

movie_parser = lambda do |source|
	data = Hash.new
	data.push('backdrop_path',source['backdrop_path'])
	data.push('budget',source['budget'])
end

var = API.call_api('movie/118340', movie_parser)
if var ==nil
	puts 'nil'
else
	puts var
end
#https://api.themoviedb.org/3/movie/118340?api_key=b52469d21a984a24ec19edab6da3439e

