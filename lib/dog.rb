class Dog
  attr_accessor :name, :id, :breed

  def initialize(name:, breed:, id: nil)
    @breed = breed
    @name = name
    @id = id
    end

    #create_table

    def self.create_table
        sql = <<- SQL
            CREATE TABLE IF NOT EXISTS dogs (
                id INTEGER PRIMARY KEY,
                name TEXT, 
                breeed TEXT
            )
        SQL
        DB[:conn].execute(sql)
    end
end
