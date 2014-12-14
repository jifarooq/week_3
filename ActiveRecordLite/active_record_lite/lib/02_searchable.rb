require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    keys = params.keys.map(&:to_s)
    where_stmnt = keys.join(' = ? AND ') + ' = ?'

    query = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_stmnt}
     SQL

     parse_all(query)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
