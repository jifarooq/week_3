require_relative 'questions_db'
# require_relative 'question'

class User

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map{ |result| User.new(result) }
  end
  
  attr_accessor :id, :lname, :fname
  
  def initialize(options = {})
    @id = options['id']
    @lname = options['lname']
    @fname = options['fname']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT * 
    FROM users
    WHERE id = ?
    SQL
    
    hash = QuestionsDatabase.instance.execute(query, id)
    User.new(hash[0])
  end
  
  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT * 
    FROM users
    WHERE fname = ?
      AND lname = ?
    SQL
    
    hash = QuestionsDatabase.instance.execute(query, fname, lname)
    User.new(hash[0])
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    query = <<-SQL
    SELECT CAST(COUNT(question_likes.user_id) AS FLOAT)/ COUNT(DISTINCT(questions.id)) AS karma  
    FROM questions
    LEFT OUTER JOIN question_likes
    ON questions.id = question_likes.question_id
    WHERE questions.user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @id)
    results[0]['karma']
  end
  
  def save
    if self.id.nil?
      insert_row
    else
      update_row
    end
  end
  
  def insert_row
    params = [self.fname, self.lname]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      users (fname, lname)
    VALUES
      (?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def update_row
    params = [self.fname, self.lname, self.id]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    UPDATE
      users
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end
  
end
