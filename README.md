# 🎬 Movie Review and Recommendation Engine

## 📘 Overview

This project builds a SQL-based movie recommendation system using **PostgreSQL**. It analyzes user ratings and reviews to recommend top movies and genres. The system is designed to replicate a simplified version of how platforms like IMDb or Netflix manage user preferences and generate personalized suggestions.

---

## 🛠️ Tools & Technologies

- **PostgreSQL**
- **SQL** (DDL, DML, Views, Window Functions)
- **pgAdmin / DBeaver** (for database interaction)
- CSV (for exporting results)

---

## 🧱 Database Schema

The project uses the following normalized tables:

- `Users`: Stores user details.
- `Movies`: Stores movie metadata (title, genre, release year).
- `Ratings`: Stores user ratings for movies.
- `Reviews`: Stores textual user reviews for movies.

![ER Diagram](./images/er_diagram.png) *(Optional: Add your ER Diagram here)*

---

## 🧪 Sample Data

Sample IMDb-style data is inserted to simulate real-world user behavior:

```sql
INSERT INTO Users (username, email) VALUES ('alice', 'alice@example.com');
INSERT INTO Movies (title, genre, release_year) VALUES ('Inception', 'Sci-Fi', 2010);
INSERT INTO Ratings (user_id, movie_id, rating) VALUES (1, 1, 9.0);
SELECT m.title, ROUND(AVG(r.rating), 2) AS avg_rating
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.title;
CREATE VIEW RecommendedMovies AS
SELECT m.title, ROUND(AVG(r.rating), 2) AS avg_rating
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(r.rating_id) > 1;
CREATE VIEW UserPreferences AS
SELECT u.username, m.genre, COUNT(*) AS rated_count
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
JOIN Movies m ON r.movie_id = m.movie_id
GROUP BY u.username, m.genre;
SELECT m.title, AVG(r.rating) AS avg_rating,
RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title;
COPY (SELECT * FROM RecommendedMovies) TO '/path/output.csv' DELIMITER ',' CSV HEADER;
📌 Conclusion
This project demonstrates how SQL alone can power an effective recommendation engine. It forms a strong foundation for integrating analytics, frontend applications, or even AI-driven suggestions.
