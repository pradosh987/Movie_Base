require 'sinatra'

load 'app/Remote_Api.rb'
load 'app/classes/Nav_Page.rb'

set :port, 8080
set :static, true
set :public_folder, "public"
set :views, "views"

get '/' do
  now = Remote_Api.get_now_playing_movies(true)
  upcoming = Remote_Api.get_upcoming_movies(true)
  erb :index, :locals => {'now' => now, 'upcoming'=> upcoming }
end

get '/movie/:id'	do
	id = params[:id]
  var = Remote_Api.get_movie_details(id)
erb :movie, :locals=>{'id'=> id, 'data'=> var} 
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
  erb :list, :locals => {'title' => title, 'page' => var}
end

# get '/list/:caller/:id/:page' do
#   caller = params[:caller]
#   id = params[:id] 
#   page = params[:page] || 1
#   title = 'Movie Base'
#   if caller=='genre'
#     var = Remote_Api.get_movies_by_genre(id)
#     title = 'Genre'
#   else
#     var = Remote_Api.get_movies_by_company(id)
#     title = 'Company'
#   end
#   erb :list_old, :locals => {'title' => title, 'data' => var}
# end

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
  erb :profile, :locals => {'data' => profile_info}
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
