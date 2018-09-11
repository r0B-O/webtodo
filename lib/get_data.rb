require 'pg'
require 'xmlbuilder'

def read_db
    conn = PG::Connection.open(:dbname => 'todo')
    res = conn.exec_params('SELECT * FROM todo_list')
    slno = "slno"
    task = "task"
    task_list = []
    
    for field in res
        todo_task= {}
        todo.merge!(:slno => field['slno'])
        todo_hash.merge!(:task => field['task'])
        task_list.push(todo_hash)
    end
    return task_list
end

def write_db(new_task)
    conn = PG::Connection.open(:dbname => 'todo')
    write_query = "INSERT INTO todo_list VALUES (#{new_task[slno]}, #{new_task[task]})"
    res = conn.exec_params(write_query)
end

puts read_db

