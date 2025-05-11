CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    age INT
);

INSERT INTO users (name, email, age)
SELECT
    'User ' || generate_series(1, 10),
    'user' || generate_series(1, 10) || '@example.com',
    floor(random() * 50 + 18)::int
;