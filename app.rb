require 'sinatra'
load 'app/API.rb'

set :port, 8080
set :static, true
set :public_folder, "public"
set :views, "views"

get '/' do
    now = API.call_api('movie/now_playing')
    upcoming = API.call_api('movie/upcoming')
    #erb :404 if var==nil
    erb :index, :locals => {'now' => now, 'upcoming'=> upcoming, 'image_host'=>'https://image.tmdb.org/t/p/w185/'}
end
get '/movie/:id'	do
	id = params[:id]
    var = "done"
	var = API.call_api('movie/' + id.to_s)
    similar = API.call_api('movie/' + id.to_s + '/similar')
    cast = API.call_api('movie/' + id.to_s + '/credits')
    reviews = API.call_api('movie/' + id.to_s + '/reviews')
	erb :movie, :locals=>{'id'=> id, 'data'=> var, 'similar'=> similar, 'cast'=>cast, 'reviews' => reviews}

    #/movie/{id}/reviews 
    #https://api.themoviedb.org/3/movie/118340/credits?api_key=b52469d21a984a24ec19edab6da3439e
end

get '/list/:caller/:id' do
    caller = params[:caller]
    id = params[:id] 
    title = 'Movie Base'
    if caller=='genre'
        var = API.call_api('genre/'+id+'/movies')
        title = 'Genre'
    else
        var = API.call_api('company/'+ id +'/movies')
        title = 'Company'
    end
    erb :list, :locals => {'title' => title, 'data' => var}
end

get '/list/:caller/:id/:page' do
    caller = params[:caller]
    id = params[:id] 
    page = params[:page] || 1
    title = 'Movie Base'
    if caller=='genre'
        var = API.call_api('genre/'+id+'/movies','page='+page)
        title = 'Genre'
    else
        var = API.call_api('company/'+ id +'/movies','page='+page)
        title = 'Company'
    end
    erb :list, :locals => {'title' => title, 'data' => var}
end

post '/search/' do
	keyword = params[:keyword]
    keyword = 'query=' + CGI::escape(keyword)
    var = API.call_api('search/movie',keyword)
    # var.inspect
    #puts var.inspect
    title = 'Search - ' + params[:keyword]
	erb :list, :locals => {'title' => title, 'data' => var} 
end

get '/profile/:id' do
  id = params[:id]
  profile_info = API.call_api('person/' + id.to_s)
  starred_in = API.call_api('person/' + id.to_s + '/movie_credits')
  erb :profile, :locals => {'data' => profile_info, 'starred_in' => starred_in}
end

#https://api.themoviedb.org/3/person/8691/movie_credits?api_key=b52469d21a984a24ec19edab6da3439e
#https://api.themoviedb.org/3/person/73457?api_key=b52469d21a984a24ec19edab6da3439e'

get '/now_playing/' do
    var = API.call_api('movie/now_playing')
    title = 'Now Playing'
    erb :list, :locals => {'title' => title, 'data' => var}
end

get '/popular/' do
    var = API.call_api('movie/popular')
    erb:list, :locals => {'title' => 'Popular Movies', 'data' => var}
end

get '/upcoming/' do
    var = API.call_api('movie/upcoming')
    erb:list, :locals => {'title' => 'Upcoming Movies', 'data' => var}
end

#post '/list/' do
#    greeting = params[:greeting] || "Hi There"
#    name = params[:name] || "budy"
#    erb :list, :locals => {'greeting' => greeting, 'name' => name}
#end