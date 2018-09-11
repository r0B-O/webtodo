require 'sinatra'
require 'pg'
require 'lib/get_data.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

todo_list = read_db
@results = {}



get '/' do
    todo_list = read_db
    erb :index
end

get '/new' do
    erb :new_form
end

post '/new' do
    todo_list = read_db
    erb :new_form
end