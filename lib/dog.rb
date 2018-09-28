class Dog
  attr_accessor :id, :name, :breed

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
    SQL

    DB[:conn].execute(sql)
  end

  def self.new_from_db
    sql = <<-SQL
      SELECT * FROM dogs;
    SQL

    db_dogs = DB[:conn].execute(sql).flatten
    db_dogs.collect do |dog|
      self.new(dog[1], dog[2], dog[0])
    end
  end
end
