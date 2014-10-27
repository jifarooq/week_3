# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  question   :text             not null
#  poll_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
  validates :question, :poll_id, presence: true
  
  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )
  
  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )
  
  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )
  
  def results
    results = Hash.new(0)
    
    answer_choices.each do |choice|
      results[choice.answer_choice] = choice.responses.count
    end 

    results  
  end
  
  def results2
    results = Hash.new(0)
    
    choices_with_responses = answer_choices.includes(:responses)
    
    choices_with_responses.each do |choice|
      results[choice.answer_choice] = choice.responses.length
    end 
      
    results  
  end
  
  def results3 
    results = AnswerChoice.find_by_sql([<<-SQL, self.id])
      SELECT answer_choices.*, COUNT(*) AS choice_count
      FROM answer_choices
      JOIN responses ON responses.answer_choice_id = answer_choices.id
      WHERE answer_choices.question_id = ?
      GROUP BY answer_choices.*
    SQL
    
    choices_with_responses = Hash.new()
    
    results.each_with_index do |result, idx|
      choices_with_responses[results[idx].answer_choice] = results[idx].choice_count
    end
    
    choices_with_responses
  end
  
  def results4
    choices = self.answer_choices
      .select('answer_choices.id AS crazy_num, answer_choices.answer_choice AS what_is_this, COUNT(responses.id) AS response_count')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .group('answer_choices.id')
  end
  
end

 # .where(question_id: = 'answer_choices.id')
