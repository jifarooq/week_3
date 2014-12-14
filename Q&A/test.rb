require_relative 'questions_db'
require_relative 'user'
require_relative 'question'
require_relative 'question_follower'
require_relative 'reply'
require_relative 'question_like'


# p User.find_by_id(3)
# p User.find_by_name('Bruce', 'Wayne')
# p Question.find_by_id(1)
# p QuestionLike.find_by_id(1)
# p Reply.find_by_id(1)
# p QuestionFollower.find_by_id(1)

# p User.find_by_id(1).authored_questions
# p User.find_by_id(1).authored_replies
# p Question.find_by_author_id(1)
# p Question.find_by_id(1).author
# p Question.find_by_id(3).replies

# p Reply.find_by_id(1).author
# p Reply.find_by_id(1).question
# p Reply.find_by_id(1).parent_reply
# p Reply.find_by_id(1).child_replies
# p QuestionFollower.followers_for_question_id(1)
# p QuestionFollower.followed_questions_for_user_id(1)
# p User.find_by_id(1).followed_questions
# p Question.find_by_id(1).followers

# p QuestionFollower.most_followed_questions(1)
# p Question.most_followed(2)

# p QuestionLike.likers_for_question_id(4)
# p QuestionLike.num_likes_for_question_id(4)
# p QuestionLike.liked_questions_for_user_id(1)

# p Question.find_by_id(4).likers
# p Question.find_by_id(4).num_likes
# p User.find_by_id(1).liked_questions
# p QuestionLike.most_liked_questions(3)
# User.all.each {|user| puts "#{user.fname} #{user.average_karma}" }
# coffee = User.new({'lname' => 'Script', 'fname' => 'Coffee'})
# coffee.save
# pop = User.find_by_id(7)
# pop.lname = 'Revealed'
# pop.fname = 'Batman'
# pop.save

# question = Question.new({'title' => 'Ramen', 'body' => 'Why dont we put potatoes in ramen?', 'user_id' => 4})
# question.save
# q2 = Question.find_by_id(2)
# q2.body = "How many buses does it take to make gingerbread man dance?"
# q2.save
reply = Reply.new({'user_id' => 7, 'question_id' => 2, 'parent_reply_id' => 3, 'body' => '42 buses! Tested and verified'})
reply.save
r2 = Reply.find_by_id(3)
r2.body = 'A much better question!'
r2.save





