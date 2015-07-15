require 'sinatra'
load 'app/API.rb'

set :port, 8081
set :static, true
set :public_folder, "public"
set :views, "views"

get '/' do
    return 'This will be Homepage'
end
get '/movie/:id'	do
	id = params[:id]
	var = API.call_api('movie/' + id.to_s)
	var.inspect
#	erb :movie, :locals=>{'id'=> id}
end

get '/list/:caller/:id' do
    caller = params[:greeting]
    id = params[:name] 
    erb :list#, :locals => {'greeting' => greeting, 'name' => name}
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