require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(id= nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"

    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
    sql = "INSERT INTO students (name, grade) VALUES (?,?);"
    
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    new_student = self.new(row[1],row[2])
    new_student.id = row[0]
    new_student
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name = ?'

    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end



end
