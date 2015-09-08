DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_id INTEGER REFERENCES replies(id),
  author_id INTEGER REFERENCES users(id),
  body TEXT NOT NULL
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Albert', 'Einstein'),
  ('Kurt', 'Godel'),
  ('Ned', 'Stark');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('I have a cat', 'How do I skin a cat?', (SELECT id FROM users WHERE fname = 'Albert' AND lname = 'Einstein')),
  ('Where is my head', 'I seem to have lost my head, has anyone seen it?', (SELECT id FROM users WHERE fname = 'Ned' AND lname = 'Stark')),
  ('Why is it so hot?', 'I''ve noticed it is really hot today and was curious about why that might be', (SELECT id FROM users WHERE fname = 'Albert' AND lname = 'Einstein'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (3, 2),
  (2, 1),
  (3, 1),
  (1, 3),
  (2, 3);

INSERT INTO
  replies (question_id, parent_id, author_id, body)
VALUES
  (1, NULL, 2, 'There are many ways.'),
  (1, 1, 3, 'Some are worse than others');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 2),
  (2, 1),
  (2, 2),
  (3, 2);
