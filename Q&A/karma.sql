SELECT * 
FROM questions JOIN ( SELECT question_id, COUNT(question_likes.user_id) AS count
  FROM question_likes 
  GROUP BY question_id
  ORDER BY count DESC
  LIMIT ?
) AS most_liked_questions 
ON questions.id = most_liked_questions.question_id

SELECT CAST(COUNT(question_likes.user_id) AS FLOAT)/ COUNT(DISTINCT(questions.id))  
FROM questions
LEFT OUTER JOIN question_likes
ON questions.id = question_likes.question_id
WHERE questions.user_id = 3