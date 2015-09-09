require 'active_support/inflector'
class ModelBase

  def self.find_by_id(id)
    # debugger
    info = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
      WHERE
        id = #{id}
    SQL
    self.new(info.first)
  end

  def self.all
    info = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
    SQL
    info.map { |el| self.new(el) }
  end

  

end
