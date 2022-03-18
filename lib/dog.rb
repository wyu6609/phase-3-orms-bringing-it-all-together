class Dog
  attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @id = id
        @name = name
        @breed = breed
    end

    #create_table - create the table

    def self.create_table
        sql = <<- SQL
            CREATE TABLE IF NOT EXISTS dogs (
                id INTEGER PRIMARY KEY,
                name TEXT, 
                breed TEXT
            )
        SQL
        DB[:conn].execute(sql)
    end

    #drop_table --> drop the dogs table from database
    def drop_table
        sql = "DROP TABLE IF EXISTS dogs"
        DB[:conn].execute(sql)
        # DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    end

    #save - add row to sql database

    def save 
        sql = <<- SQL
        INSERT INTO dogs (name,breed)
        VALUES (?,?)
        SQL

        #INSERT THE SONG
        DB[:conn].execute(sql,self.name,self.breed)

        #get the song id from the database
        self.id = DB[:conn].execute("SELECT last_insert_row FROM dogs")[0][0]

        # return RUBY instance
        self
    end


    #create new instance and save it
    def self.create(name:, album:)
        song = Song.new(name: name, album: album)
    end


    #.new_from_db

    def self.new_from_db
        self.new(id: row[0], name:row[1], breed: row[2])
    end

    #all

    def self.all
        sql = <<-SQL
            SELECT * 
            FROM dogs;
        SQL
        # select all fror each row
        DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
    end








end

























end
