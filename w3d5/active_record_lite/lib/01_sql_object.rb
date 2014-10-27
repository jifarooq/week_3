require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # return @columns if @columns
    sql = "SELECT * FROM #{self.table_name}"
    query = DBConnection.execute2(sql)

    @columns = query.first.map { |col| col.to_sym }
  end

  def self.finalize!
    self.columns.each do |col|
      define_method col do
        # @attributes[col]
        self.attributes[col]
      end

      define_method "#{col}=" do |val|
        #need to use self.attributes here, not @attributes
        self.attributes[col] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.downcase + 's'
  end

  def self.all
    query = DBConnection.execute(<<-SQL)
      SELECT *
      FROM "#{self.table_name}"
    SQL

    parse_all(query)
  end

  def self.parse_all(results)
    results.map{ |result| self.new(result) }
  end

  def self.find(id)
    query = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
      WHERE id = #{id}
    SQL
    
    # parse_all(query)
    self.new(query.first)
  end

  def initialize(params = {})
    params.each do |name, val|
      name = name.to_sym

      if self.class.columns.include?(name)
        #setter method
        self.send("#{ name }=", val)
      else
        raise "unknown attribute '#{name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |col|
      self.send(col)
    end
  end

  def insert
    col_names = self.class.columns.join(', ')
    question_marks = ["?"] * attribute_values.size

    #watch syntax below
    query = DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks.join(', ')})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_stmnt = self.class.columns.join(' = ?, ') + ' = ?'

    query = DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_stmnt}
      WHERE
        id = ?
      SQL
  end

  def save
    id.nil? ? insert : update
  end

end




