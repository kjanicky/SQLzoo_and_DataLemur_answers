HERE are the answers to SQLZOO exercises https://www.sqlzoo.net/wiki/SQL_Tutorial
## Sections
1.  [More JOIN](#more-join)
2.  [Window Functions](#window-functions)
3.  [Self JOIN](#self-join)

## More JOIN
1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

2. Give year of 'Citizen Kane'.
Select yr
FROM movie
WHERE title = 'Citizen Kane'

3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id,title,yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr

4. What id number does the actor 'Glenn Close' have?
SELECT id 
FROM actor
WHERE name = 'Glenn Close'

5. What is the id of the film 'Casablanca'
SELECT id 
FROM movie
WHERE title = 'Casablanca'

6. Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor
WHERE id IN (SELECT actorid FROM casting WHERE movieid = 11768)

7. Obtain the cast list for the film 'Alien'
SELECT name
FROM actor
WHERE id IN (SELECT actorid
FROM casting WHERE movieid IN (SELECT id FROM movie WHERE title = 'Alien'))

8. List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie
WHERE id IN (SELECT movieid FROM casting WHERE actorid IN
               (SELECT id FROM actor WHERE name =  'Harrison Ford'))

9. List the films where 'Harrison Ford' has appeared - but not in the starring role. (Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role)
SELECT title
FROM movie
WHERE id IN (SELECT movieid FROM casting WHERE ord <> 1 AND actorid IN (SELECT id FROM actor WHERE name = 'Harrison Ford'))

10. List the films together with the leading star for all 1962 films.
SELECT m.title, a.name
FROM movie m
INNER JOIN casting c
ON c.movieid = m.id
INNER JOIN actor a
ON a.id = c.actorid
WHERE m.yr = 1962 AND c.ord = 1

11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT m.yr, COUNT(*) as number_of_movies
FROM movie m
INNER JOIN casting c ON c.movieid = m.id
INNER JOIN actor a ON a.id = c.actorid
WHERE a.name = 'Rock Hudson'
GROUP BY m.yr
HAVING COUNT(*) > 2;

12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title,a.name
FROM movie m
INNER JOIN casting c ON c.movieid = m.id
INNER JOIN actor a ON a.id = c.actorid
WHERE m.id IN (SELECT movieid FROM casting WHERE actorid IN 
(SELECT id FROM actor WHERE name = 'Julie Andrews')) AND c.ord = 1;

13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT DISTINCT name FROM casting
  JOIN movie ON movie.id = movieid
  JOIN actor ON actor.id = actorid
  WHERE actorid IN (
	SELECT actorid FROM casting
	  WHERE ord = 1
	  GROUP BY actorid
	  HAVING COUNT(actorid) >= 15)
ORDER BY name

14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
 SELECT title,COUNT(actorid)
FROM movie m
INNER JOIN casting c
ON c.movieid = m.id
WHERE yr = 1978
GROUP BY yr,title
ORDER BY 2 DESC,1 

15. List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name FROM casting
  JOIN actor ON actorid = actor.id
  WHERE name != 'Art Garfunkel'
	AND movieid IN (
		SELECT movieid
		FROM movie
		JOIN casting ON movieid = movie.id
		JOIN actor ON actorid = actor.id
		WHERE actor.name = 'Art Garfunkel'
)
