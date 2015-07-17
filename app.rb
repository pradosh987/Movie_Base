require 'sinatra'

load 'app/Remote_Api.rb'
load 'app/classes/Nav_Page.rb'
load 'app/API.rb'

set :port, 8080
set :static, true
set :public_folder, "public"
set :views, "views"

get '/' do
  now = Remote_Api.get_now_playing_movies(true)
  upcoming = Remote_Api.get_upcoming_movies(true)
  erb :index, :locals => {'now' => now, 'upcoming'=> upcoming, 'image_host'=>'https://image.tmdb.org/t/p/w185/'}
end

get '/movie/:id'	do
	id = params[:id]
  var = Remote_Api.get_movie_details(id)
  similar = Remote_Api.get_similar_movies(id)
  cast = Remote_Api.get_cast_from_movie(id)
  reviews = Remote_Api.get_reviews_of_movie(id)
  erb :movie, :locals=>{'id'=> id, 'data'=> var, 'similar'=> similar, 'cast'=>cast, 'reviews' => reviews} 
end

get '/list/:caller/:id' do
  caller = params[:caller]
  id = params[:id] 
  title = 'Movie Base'
  if caller=='genre'
    var = Remote_Api.get_movies_by_genre(id)
    title = 'Genre'
  else
    var = Remote_Api.get_movies_by_company(id)
    title = 'Company'
  end
  erb :list_old, :locals => {'title' => title, 'data' => var}
end

get '/list/:caller/:id/:page' do
  caller = params[:caller]
  id = params[:id] 
  page = params[:page] || 1
  title = 'Movie Base'
  if caller=='genre'
    var = Remote_Api.get_movies_by_genre(id)
    title = 'Genre'
  else
    var = Remote_Api.get_movies_by_company(id)
    title = 'Company'
  end
  erb :list_old, :locals => {'title' => title, 'data' => var}
end

post '/search/' do
  keyword = params[:keyword]
  keyword = CGI::escape(keyword)
  var = Remote_Api.search(keyword)
  title = 'Search - ' + params[:keyword]
  erb :list, :locals => {'title' => title, 'page' => var} 
end

get '/profile/:id' do
  id = params[:id]
  profile_info = Remote_Api.get_profile(id)
  starred_in = Remote_Api.get_movies_starred_by(id)
  erb :profile, :locals => {'data' => profile_info, 'starred_in' => starred_in}
end

get '/now_playing/' do
  var = Remote_Api.get_now_playing_movies
  title = 'Now Playing'
  erb :list, :locals => {'title' => title, 'page' => var}
end

get '/popular/' do
  var = Remote_Api.get_popular_movies
  erb :list, :locals => {'title' => 'Popular Movies', 'page' => var}
end

get '/upcoming/' do
  var = Remote_Api.get_upcoming_movies
  erb :list, :locals => {'title' => 'Upcoming Movies', 'page' => var}
end

#test code block
get '/test/' do
  var = Remote_Api.get_upcoming_movies
  erb :list, :locals => {'title' => 'Upcoming Movies', 'page' => var} 
  #puts 'here:' + var.page.to_s
  # var.data.each {|x| puts x.name}
  # "HEllo"
end