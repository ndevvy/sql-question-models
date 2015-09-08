require_relative 'questions_manifest'

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.followers_for_question_id(question_id)
    user_info = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL

    user_info.map { |user_info| User.new(user_info) }
  end

  def self.followed_questions_for_user_id(user_id)
    question_info = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL

    question_info.map { |question_info| Question.new(question_info) }
  end

  def self.most_followed_questions(n)
      question_info = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT ?
      SQL

      question_info.map { |question_info| Question.new(question_info) }
  end

end
