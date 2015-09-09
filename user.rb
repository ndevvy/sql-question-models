require_relative 'questions_manifest'

class User < ModelBase

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
      users (fname, lname)
      VALUES
      ( ?, ?)
      SQL

      self.id = QuestionsDatabase.instance.last_insert_row_id

    else
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = #{self.id}
      SQL
    end

  end

  # def self.find_by_id(id)
  #   user_info = QuestionsDatabase.instance.execute(<<-SQL, id)
  #     SELECT
  #       *
  #     FROM
  #       users
  #     WHERE
  #       id = ?
  #   SQL
  #
  #   User.new(user_info.first)
  # end

  def self.find_by_name(fname, lname)
    user_info = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(user_info.first)
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT
      CAST(COUNT(question_likes.question_id) AS FLOAT) / COUNT(DISTINCT(questions.id))
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      questions.author_id = ?
    SQL
    karma.last[0]
  end

end
