class Dog
  attr_accessor :name, :breed, :id

  def initialize(name:, breed:, id: nil)
    @id = id
    @name = name
    @breed = breed
  end

  #create table
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
          id INTEGER PRIMARY KEY,
          name TEXT, 
          breed TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  # drop dogs table from DB

  def self.drop_table
    sql = 'DROP TABLE IF EXISTS dogs'
    DB[:conn].execute(sql)
  end

  #save -- insert new record into the database & return the instance
  def save
    sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES(?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute('SELECT last_insert_rowid() FROM dogs')[0][0]

    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
  end

  #create new row in DB, return new instance of DOG CLASS
  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end

  #all- return an array of Dog instances for every record in the dogs table
  def self.all
    sql = <<-SQL
        SELECT *
        FROM dogs;
    SQL
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  # insert a dog into the database, find it by calling the find_by_name
  def self.find_by_name(name)
    sql = <<-SQL
            SELECT *
            FROM dogs
            WHERE dogs.name = ? 
            LIMIT 1;
        SQL
    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
  end

  #takes in an ID, should return a single DOG instance

  def self.find(id)
    sql = <<-SQL
          SELECT *
          FROM dogs
          WHERE dogs.id = ?
          LIMIT 1;
        SQL

    DB[:conn].execute(sql, id).map { |row| self.new_from_db(row) }.first
  end
end
