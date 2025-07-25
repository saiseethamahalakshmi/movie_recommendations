-- USERS Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

-- MOVIES Table
CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    release_year INT
);

-- RATINGS Table
CREATE TABLE Ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    movie_id INT REFERENCES Movies(movie_id),
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 10),
    rated_on DATE DEFAULT CURRENT_DATE
);

-- REVIEWS Table
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    movie_id INT REFERENCES Movies(movie_id),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);
-- Sample Users
INSERT INTO Users (username, email) VALUES 
('arjun', 'arjun@gmail.com'),
('krishna', 'krishna@gmail.com'),
('pardhu', 'pardhu@gmail.com');

-- Sample Movies
INSERT INTO Movies (title, genre, release_year) VALUES 
('Athadu', 'comercial', 2010),
('seethamma vakitlo serimalle chettu', 'family', 1972),
('ante sundariniki', 'Rom com', 2019),
('maghadheera', 'Action', 2019);

-- Sample Ratings
INSERT INTO Ratings (user_id, movie_id, rating) VALUES 
(1, 1, 9.0),
(1, 2, 8.5),
(2, 1, 8.7),
(2, 3, 9.1),
(3, 1, 9.2),
(3, 4, 8.9);

-- Sample Reviews
INSERT INTO Reviews (user_id, movie_id, review_text) VALUES 
(1, 1, 'Mind-blowing visuals and story.'),
(2, 3, 'A masterpiece of suspense and social commentary.'),
(3, 4, 'Epic finale to a great saga.');
-- Average rating per movie
SELECT 
    m.title, 
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating_id) AS total_ratings
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;
-- View: Top rated movies with more than 1 rating
CREATE VIEW RecommendedMovies AS
SELECT 
    m.movie_id,
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating_id) AS rating_count
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(r.rating_id) > 1
ORDER BY avg_rating DESC;
-- View: User-specific recommended genres
CREATE VIEW UserPreferences AS
SELECT 
    u.user_id,
    u.username,
    m.genre,
    COUNT(*) AS rated_count,
    ROUND(AVG(r.rating), 2) AS avg_genre_rating
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY u.user_id, u.username, m.genre;
-- Rank movies by average rating using window function
SELECT 
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title;
-- Export data from the RecommendedMovies view
SELECT * FROM RecommendedMovies;





