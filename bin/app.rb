require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
    erb :index
end

get '/new/' do
    slno = params[:slno] || ""
    date = params[:date] || ""
    task = params[:task] || ""
    erb :new_form, :locals => {'slno' => slno, 'date' => date, 'task' => task}
end