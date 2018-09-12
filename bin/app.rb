## Connects with PostgreSQL DB and fethces the data
## DB is read and then the table is stored into a list of hashes
## The hash is then used to create an HTML table using gem 'builder'
## The xml object is then merged into index.erb to be sent to user for 'GET' request

# Gems => pg - PostgreSQL, builder - xml builder
require 'sinatra'
require 'pg'
require 'builder'

# Function to read the database and create list with table records
def read_db
    conn = PG::Connection.open(:dbname => 'tododb')
    res = conn.exec_params('SELECT * FROM todo_list')
    slno = "slno"
    task = "task"
    todo_list = []
    
    for field in res
        todo= {}
        todo.merge!(:slno => field['slno'])
        todo.merge!(:task => field['task'])
        todo_list.push(todo)
    end
    return todo_list
end

# Write the newly created task to the DB using INSERT
def write_db(new_task)
    conn = PG::Connection.open(:dbname => 'todo')
    write_query = "INSERT INTO todo_list VALUES (#{new_task[slno]}, #{new_task[task]})"
    res = conn.exec_params(write_query)
end

# Create a table from the list of records read from DB
def get_table
    todo_list = read_db
    # puts todo_list

    xm = Builder::XmlMarkup.new(:indent => 1)
    xm.table {
        xm.tr {todo_list[0].keys.each { |key| xm.th(key)}}
        todo_list.each { |row| xm.tr { row.values.each { |value| xm.td(value)}}}
    }

    # Split the string and then convert to list
    xml_table = xm.split(/\n+/)
    xml_list = []
    xml_table.each_line do |line|
        xml_list = xml_list.push(line)
    end
    xml_list.pop
    return xml_list
end

# Merge the table in xml format with index.erb file
def build_index_fle
    # index_erb - styling and header, table - xml table from db, add_link - href to add new task
    index_erb = ['<h3 align="center">Tasks to do are listed below:</h3>', '<style>', 'table, th, td {', '        width: 50%;', '        border: 1px solid black;', '        border-collapse: collapse;', '}', '</style>']
    table = get_table
    table_as_list = []
    add_link = ['<div style="text-align:center">', '        <br/><br/><br/><br/><br/>', '        <a href="/new">Add New Task</a>', '</div>']      
    # index_file is final index page
    index_file = index_erb + table + add_link
    puts index_file
     
    file_name = ( "views/index.erb")
    file = open(file_name, 'a+')
    file.truncate(0)
    # Writes the contents of the array into the file
    puts "Building index file..."
    index_file.each do |line|
      file.write("#{line}\n")
    end
    file.close
end

# Cinfiguration for Sinatra Methods
set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

# GET Request Handler for route '/'
# Route is the path requested
get '/' do
    build_index_fle
    erb :index
end

# GET Request to add a new task, via route '/new'
get '/new' do
    erb :new_form
end

# Post request to submit the new task form
post '/new' do
    erb :new_form
end