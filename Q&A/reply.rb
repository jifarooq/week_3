require_relative 'questions_db'

class Reply

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map{ |result| Reply.new(result) }
  end
  
  attr_accessor :id, :user_id, :question_id, :parent_reply_id, :body
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT * 
    FROM replies
    WHERE id = ?
    SQL
    
    hash = QuestionsDatabase.instance.execute(query, id)
    Reply.new(hash[0])
  end
  
  def self.find_by_question_id(question_id)
    query = <<-SQL
    SELECT * 
    FROM replies
    WHERE question_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map{ |result| Reply.new(result) }
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT * 
    FROM replies
    WHERE user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map{ |result| Reply.new(result) }
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
  
  def question
    query = <<-SQL
    SELECT * 
    FROM questions
    WHERE id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @question_id)
    Question.new(results[0])
  end
  
  def parent_reply
    query = <<-SQL
    SELECT * 
    FROM replies
    WHERE id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @parent_reply_id)
    results.map{ |result| Reply.new(result) }
  end
  
  def child_replies
    query = <<-SQL
    SELECT * 
    FROM replies
    WHERE parent_reply_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @id)
    results.map{ |result| Reply.new(result) }
  end
  
  def save
    if self.id.nil?
      insert_row
    else
      update_row
    end
  end
  
  def insert_row
    params = [self.user_id, self.question_id, self.parent_reply_id, self.body]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      replies (user_id, question_id, parent_reply_id, body)
    VALUES
      (?, ?, ?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def update_row
    params = [self.user_id, self.question_id, self.parent_reply_id, self.body, self.id]
    
    QuestionsDatabase.instance.execute(<<-SQL, *params)
    UPDATE
      replies
    SET
      user_id = ?, question_id = ?, parent_reply_id = ?, body = ?
    WHERE
      id = ?
    SQL
  end
  
end