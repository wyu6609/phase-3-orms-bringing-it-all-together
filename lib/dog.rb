class Dog
  attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @id = id
        @name = name
        @breed = breed
    end

    #create_table

    def self.create_table(name:,breed:)
        sql = <<- SQL
        CREATE TABLE IF NOT EXISTS dogs (
             id INTEGER PRIMARY KEY,
             name TEXT, 
             breed TEXT,
        )
        SQL
        DB[:conn].execute(sql)
    end

    #drop_table

    def drop_table
        sql = "DROP TABLE IF NOT EXISTS dogs"
        DB[:conn].execute(sql)
    end

    #save - insert new row
    def save
        sql = <<- SQL
            INSERT INTO dogs (name,breed)
            VALUES (?,?)
        SQL
        DB[:conn].execute(sql, self.name, self.breed)
        #update current id
        self.id = DB[:conn].execute("SELECT last_inserted_row() FROM dogs")[0][0]
        
        self
    end

   #create
    def self.create(name:,breed:)
        dog = Dog.new(name:name,breed:breed)
        dog.save
    end

    #new_from_db
    def new_from_db
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
        sql = <<- SQL
            SELECT * 
            FROM dogs;
        SQL

        DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
    end

    def self.find_by_name(name)
        sql = <<- SQL
            SELECT * 
            FROM dogs
            WHERE dogs.name = ?
            LIMIT 1;
        SQL

        DB[:conn].execute(sql,self.name).map{|row| self.new_from_db(row)}.first 
    end


    def self.find(id)
        sql = <<- SQL
            SELECT * 
            FROM dogs
            WHERE dogs.id = ?
            LIMIT 1;
        SQL
        DB[:conn].execute(sql,self.id).map{|row| self.new_from_db(row)}.first
    end
end

























end
