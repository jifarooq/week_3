# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  answer_choice_id :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Response < ActiveRecord::Base
  validates :answer_choice_id, :user_id, presence: true
  validate :user_cannot_repond_again
  validate :author_cannot_respond_to_own_poll
  
  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id 
  )
  
  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )
  
  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )
  
  def sibling_responses
    if self.id.nil?
      self.question.responses
    else
      self.question.responses.where('responses.id != ?', self.id)
    end
  end
  
  private
  def user_cannot_repond_again
    all_siblings = self.sibling_responses
    
    all_siblings.each do |response|
      if response.user_id == self.user_id
        errors[:base] << "User has already responded"
      end
    end
  end
  
  def author_cannot_respond_to_own_poll
    if self.answer_choice.question.poll.author_id == self.user_id
      errors[:base] << "User may not respond to their own poll"
    end  
  end
      
   
end
