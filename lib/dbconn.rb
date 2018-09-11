## Connects with PostgreSQL DB and fethces the data
## DB is read and then the table is stored into a list of hashes
## The hash is then used to create an HTML table using gem 'builder'
## The xml object is then merged into index.erb to be sent to user for 'GET' request

# Gems => pg - PostgreSQL, builder - xml builder
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

    return xm
end

# Merge the table in xml format with index.erb file
def build_index_fle
    current_line = 1
    table = get_table
    index_erb = IO.readlines("./views/index.erb")
    index_erb.each do |line|
        if if ( line =~ /</style>/)
            index_erb.insert(current_line, table)
        end
        current_line += 1
    end
end
