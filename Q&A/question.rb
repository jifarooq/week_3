require_relative 'questions_db'

class Question

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map{ |result| Question.new(result) }
  end
  
  # attr_reader :id, :title, :body
  attr_accessor :id, :title, :body, :user_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT * 
    FROM questions
    WHERE id = ?
    SQL
    
    hash = QuestionsDatabase.instance.execute(query, id)
    Question.new(hash[0])
  end
  
  def self.find_by_author_id(author_id)
    query = <<-SQL
    SELECT * 
    FROM questions
    WHERE user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, author_id)
    results.map{ |result| Question.new(result) }
  end
  
  def author
    query = <<-SQL
    SELECT * 
    FROM users
    WHERE id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @user_id)
    User.new(results[0])
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers   
    QuestionFollower.followers_for_question_id(@id)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  def save
    if self.id.nil?
      insert_row
    else
      update_row
    end
  end
  
  def insert_row
    params = [self.title, self.body, self.user_id]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      questions (title, body, user_id)
    VALUES
      (?, ?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def update_row
    params = [self.title, self.body, self.user_id, self.id]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    UPDATE
      questions
    SET
      title = ?, body = ?, user_id = ?
    WHERE
      id = ?
    SQL
  end
  
end