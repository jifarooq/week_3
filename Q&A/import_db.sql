CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL, 
  body TEXT, 
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id) 
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)  
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)  
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Bruce', 'Wayne'),
  ('Sailor', 'Moon'),
  ('Sala', 'Mander'),
  ('Popeye', 'Chicken');

INSERT INTO
 questions (title, body, user_id)
VALUES
  ('Evil?', 'What is the root of all evil?', (SELECT id FROM users WHERE lname = 'Wayne')),
  ('Buses', 'How many buses are there in the world?', (SELECT id FROM users WHERE lname = 'Moon')),
  ('Coffee', 'Where is the nearest cafe?', (SELECT id FROM users WHERE lname = 'Chicken')),
  ('Exercise', 'How does one stay a couch potato?', (SELECT id FROM users WHERE lname = 'Mander')),
  ('Food', 'Is there a potato under the couch?', (SELECT id FROM users WHERE lname = 'Mander'));

INSERT INTO
  question_followers(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Wayne'), (SELECT id FROM questions WHERE title = 'Evil?')),
  ((SELECT id FROM users WHERE lname = 'Wayne'), (SELECT id FROM questions WHERE title = 'Exercise')),
  ((SELECT id FROM users WHERE lname = 'Chicken'), (SELECT id FROM questions WHERE title = 'Coffee')),
  ((SELECT id FROM users WHERE lname = 'Mander'), (SELECT id FROM questions WHERE title = 'Evil?'));
  
INSERT INTO
  replies(user_id, question_id, parent_reply_id, body)
VALUES
  ((SELECT id FROM users WHERE lname = 'Wayne'), (SELECT id FROM questions WHERE title = 'Coffee'), NULL, "I'll drop some from the sky for you."),
  ((SELECT id FROM users WHERE lname = 'Moon'), (SELECT id FROM questions WHERE title = 'Coffee'), 1, "Ask your office manager. They're faster than Bruce."),
  ((SELECT id FROM users WHERE lname = 'Mander'), (SELECT id FROM questions WHERE title = 'Buses'), NULL, "Google it.");

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Wayne'), (SELECT id FROM questions WHERE title = 'Exercise')),
  ((SELECT id FROM users WHERE lname = 'Wayne'), (SELECT id FROM questions WHERE title = 'Coffee')),
  ((SELECT id FROM users WHERE lname = 'Chicken'), (SELECT id FROM questions WHERE title = 'Exercise')),
  ((SELECT id FROM users WHERE lname = 'Chicken'), (SELECT id FROM questions WHERE title = 'Food'));
  

