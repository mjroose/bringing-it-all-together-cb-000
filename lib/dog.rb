class Dog
  attr_accessor :id, :name, :breed

  def initialize(dog_attr)
    @name = dog_attr.name
    @breed = dog_attr.breed
    @id = dog_attr.id || nil
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

  def self.new_from_db(row)
    self.new(name: row[1], breed: row[2], id: row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs WHERE dogs.name = ?;
    SQL

    dog_data = DB[:conn].execute(sql, name).flatten
    self.new_from_db(dog_data[0])
  end

  def save
    insert_sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?);
    SQL

    last_id_sql = <<-SQL
      SELECT last_insert_rowid();
    SQL

    DB[:conn].execute(insert_sql, self.name, self.breed)
    self.id = DB[:conn].execute(last_id_sql)[0][0]
    self
  end

  def self.create(name:, breed:)
    dog = self.new(name, breed)
    dog.save
    dog
  end
end
