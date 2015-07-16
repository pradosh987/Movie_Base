require 'sinatra'
load 'app/API.rb'

set :port, 8080
set :static, true
set :public_folder, "public"
set :views, "views"

get '/' do
    var = API.call_api('movie/now_playing')
    #erb :404 if var==nil
    erb :index, :locals => {'data' => var, 'image_host'=>'https://image.tmdb.org/t/p/w185/'}
end
get '/movie/:id'	do
	id = params[:id]
	var = API.call_api('movie/' + id.to_s)
	erb :movie, :locals=>{'id'=> id, 'data'=> var, 'image_host'=>'https://image.tmdb.org/t/p/w185/'}
end

get '/list/:caller/:id' do
    caller = params[:caller]
    id = params[:id] 
    if caller=='genre'
    	API.call_api('genre/'+id+'/movies',lambda {|source| source['results']}).to_s
    else
    	caller
    end
#    erb :list#, :locals => {'greeting' => greeting, 'name' => name}
end

get '/search/:title' do
	title = params[:title]
	erb :search
end

#post '/list/' do
#    greeting = params[:greeting] || "Hi There"
#    name = params[:name] || "budy"
#    erb :list, :locals => {'greeting' => greeting, 'name' => name}
#end