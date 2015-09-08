require_relative 'questions_manifest'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    liker_info = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_likes ON users.id = question_likes.user_id
    WHERE
      question_likes.question_id = ?
    SQL
    liker_info.map { |liker_info| User.new(liker_info) }
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.instance.execute(<<-SQL, question_idq)
    SELECT
      COUNT(user_id)
    FROM
      question_likes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL
end

  def self.liked_questions_for_user_id(user_id)
    question_info = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = 2
    SQL

    question_info.map { |question_info| Question.new(question_info) }
  end

  def self.most_liked_questions(n)
      question_info = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT ?
      SQL
      question_info.map { |question_info| Question.new(question_info) }
  end
