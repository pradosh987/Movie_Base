require 'net/http'
require 'json'

class API
	@@remote_api_end_point = 'https://api.themoviedb.org/3/'
	@@api_key = 'b52469d21a984a24ec19edab6da3439e'

	def self.prepare_query(query)
		return @@remote_api_end_point + query + '?api_key=' + @@api_key
	end

	def self.call_api(url,parse_func = nil)
		url = append_api_key(url)
		resp = Net::HTTP.get_response(URI.parse(url))
		return nil if resp.code != 200.to_s
		response = JSON.parse(resp.body)
	 	response = parse_func.call(response) if parse_func
	end
	
end

puts API.prepare_query('movie/118340')

#https://api.themoviedb.org/3/movie/118340?api_key=b52469d21a984a24ec19edab6da3439e

