require 'pg'
require 'builder'

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

def write_db(new_task)
    conn = PG::Connection.open(:dbname => 'todo')
    write_query = "INSERT INTO todo_list VALUES (#{new_task[slno]}, #{new_task[task]})"
    res = conn.exec_params(write_query)
end

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
