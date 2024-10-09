--1.Give the name, release year, and worldwide gross??// of the lowest grossing movie.
SELECT 
	s.movie_id,
	s.film_title,
	s.release_year,
	r.worldwide_gross
FROM specs AS s
LEFT JOIN revenue AS r
ON s.movie_id=r.movie_id
ORDER BY r.worldwide_gross ASC;
-- Answer: 5976, Semi-Tough, 1977, 37187139

--COMPLETE 2.What year has the highest average imdb rating?
SELECT DISTINCT s.release_year, AVG(r.imdb_rating) AS average_rating
FROM specs AS s
INNER JOIN rating AS r
ON s.movie_id=r.movie_id
GROUP BY s.release_year
ORDER BY average_rating DESC
-- Answer:1991, average rating 7.45

--3.What is the highest grossing //??G-rated movie? Which company distributed it?
SELECT DISTINCT 
mpaa_rating,
company_name,
worldwide_gross,
film_title
FROM distributors
INNER JOIN specs
ON specs.domestic_distributor_id=distributors.distributor_id AND
specs.mpaa_rating= 'G'
INNER JOIN revenue
ON specs.movie_id=revenue.movie_id
ORDER BY revenue.worldwide_gross DESC;
-- Answer: Toy Story 4 by Walt Disney

--4.Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.distributor_id, distributors.company_name, COUNT(specs.movie_id) AS number_of_movies
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id  
WHERE specs.movie_id IS NOT NULL OR specs.movie_id IS NULL
GROUP BY distributors.distributor_id, distributors.company_name
ORDER BY number_of_movies DESC;

--5.Write a query that returns the five distributors with the highest average movie budget.
SELECT DISTINCT AVG(film_budget)AS average_budget, company_name
FROM revenue
INNER JOIN specs
ON specs.movie_id=revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id=distributors.distributor_id
GROUP BY distributors.company_name
ORDER BY average_budget DESC;
-- Answer: Walt Disney, Sony, Lionsgate, Dreamworks, Warner Bros

-- Filter for top 5 highest average movie budget

--6.How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT s.film_title, d.company_name, r.imdb_rating
FROM specs AS s
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN rating AS r
USING(movie_id)
WHERE d.headquarters NOT ILIKE '%CA'
ORDER BY r.imdb_rating DESC;

--7.Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT
CASE
WHEN length_in_min < 120 THEN 'under_2_hours'
WHEN length_in_min >= 120 THEN 'over_2_hours'
WHEN length_in_min = 120 THEN '2 hours exactly'
END AS under_over_2_hours,
ROUND(AVG(imdb_rating), 2)
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY under_over_2_hours;