require_relative 'questions_manifest'

class Reply

  attr_accessor :id, :question_id, :parent_id, :author_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    reply_info = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(reply_info.first)
  end

  def self.find_by_user_id(author_id)
    replies_info = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL
    replies_info.map { |replies_info| Reply.new(replies_info) }
  end

  def self.find_by_question_id(question_id)
    reply_info = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    reply_info.map { |reply_info| Reply.new(reply_info) }
  end

  def parent_reply
    self.class.find_by_id(parent_id)
  end

  def child_replies
    reply_info = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = #{self.id}
    SQL
    reply_info.map { |reply_info| Reply.new(reply_info) }
  end
end
