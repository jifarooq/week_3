require_relative 'questions_db'

class QuestionFollower

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map{ |result| QuestionFollower.new(result) }
  end
  
  attr_accessor :id, :user_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT * 
    FROM question_followers
    WHERE id = ?
    SQL
    
    hash = QuestionsDatabase.instance.execute(query, id)
    QuestionFollower.new(hash[0])
  end
  
  def self.followers_for_question_id(question_id)
    query = <<-SQL
    SELECT * 
    FROM users
    JOIN question_followers ON users.id = user_id
    WHERE question_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map{ |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT * 
    FROM questions
    JOIN question_followers ON questions.id = question_id
    WHERE question_followers.user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map{ |result| Question.new(result) }
  end
  
  def self.most_followed_questions(n)
    query = <<-SQL
    SELECT * 
    FROM questions JOIN ( SELECT question_id, COUNT(user_id) AS count
      FROM question_followers 
      GROUP BY question_id
      ORDER BY count DESC
      LIMIT ?
    ) AS most_followed_questions 
    ON questions.id = most_followed_questions.question_id
    SQL
    
    results = QuestionsDatabase.instance.execute(query,n)
    results.map{ |result| Question.new(result) }
  end
end