PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR,
    lname VARCHAR
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    
    FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(parent_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes ( 
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO 
    users (fname, lname)
VALUES
    ('Rohan', 'Mudumba'),
    ('Hanna', 'Darwish');

INSERT INTO
    questions (title, author_id, body)
VALUES 
    ('What day is it today?', 1, 'I don''t know what day it is. Can someone please tell me?'),
    ('Is it the weekend yet?', 2, 'Unsure how many more days until the weekend. Help.')
    

