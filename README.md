HERE are the answers to SQLZOO exercises https://www.sqlzoo.net/wiki/SQL_Tutorial
## Sections
1.  [More JOIN](#more-join)
2.  [Window Functions](#window-functions)
3.  [Self JOIN](#self-join)

## More JOIN
![image](https://github.com/kjanicky/sqlzoo_anwers/assets/162624833/394b12b6-5a16-4143-829f-41a09c818a4d)

1. List the films where the yr is 1962 [Show id, title]
```sql
SELECT id, title
 FROM movie
 WHERE yr=1962
```
2. Give year of 'Citizen Kane'.
```sql
Select yr
FROM movie
WHERE title = 'Citizen Kane'
```
3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
```sql
SELECT id,title,yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr
```
4. What id number does the actor 'Glenn Close' have?
```sql
SELECT id 
FROM actor
WHERE name = 'Glenn Close'
```
5. What is the id of the film 'Casablanca'
```sql
SELECT id 
FROM movie
WHERE title = 'Casablanca'
```
6. Obtain the cast list for 'Casablanca'.
```sql
SELECT name
FROM actor
WHERE id IN (SELECT actorid FROM casting WHERE movieid = 11768)
```
7. Obtain the cast list for the film 'Alien'
```sql
SELECT name
FROM actor
WHERE id IN (SELECT actorid
FROM casting WHERE movieid IN (SELECT id FROM movie WHERE title = 'Alien'))
```
8. List the films in which 'Harrison Ford' has appeared
```sql
SELECT title
FROM movie
WHERE id IN (SELECT movieid FROM casting WHERE actorid IN
               (SELECT id FROM actor WHERE name =  'Harrison Ford'))
```
9. List the films where 'Harrison Ford' has appeared - but not in the starring role. (Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role)
```sql
SELECT title
FROM movie
WHERE id IN (SELECT movieid FROM casting WHERE ord <> 1 AND actorid IN (SELECT id FROM actor WHERE name = 'Harrison Ford'))
```
10. List the films together with the leading star for all 1962 films.
```sql
SELECT m.title, a.name
FROM movie m
INNER JOIN casting c
ON c.movieid = m.id
INNER JOIN actor a
ON a.id = c.actorid
WHERE m.yr = 1962 AND c.ord = 1
```
11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
```sql
SELECT m.yr, COUNT(*) as number_of_movies
FROM movie m
INNER JOIN casting c ON c.movieid = m.id
INNER JOIN actor a ON a.id = c.actorid
WHERE a.name = 'Rock Hudson'
GROUP BY m.yr
HAVING COUNT(*) > 2;
```
12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
```sql
SELECT title,a.name
FROM movie m
INNER JOIN casting c ON c.movieid = m.id
INNER JOIN actor a ON a.id = c.actorid
WHERE m.id IN (SELECT movieid FROM casting WHERE actorid IN 
(SELECT id FROM actor WHERE name = 'Julie Andrews')) AND c.ord = 1;
```
13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
```sql
SELECT DISTINCT name FROM casting
  JOIN movie ON movie.id = movieid
  JOIN actor ON actor.id = actorid
  WHERE actorid IN (
	SELECT actorid FROM casting
	  WHERE ord = 1
	  GROUP BY actorid
	  HAVING COUNT(actorid) >= 15)
ORDER BY name
```
14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
 ```sql
SELECT title,COUNT(actorid)
FROM movie m
INNER JOIN casting c
ON c.movieid = m.id
WHERE yr = 1978
GROUP BY yr,title
ORDER BY 2 DESC,1 
```
15. List all the people who have worked with 'Art Garfunkel'.
```sql
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
```
## Window Functions
```sql
1. Show the lastName, party and votes for the constituency 'S14000024' in 2017.
SELECT lastName, party, votes
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC
```
2. Show the party and RANK for constituency S14000024 in 2017. List the output by party
```sql
SELECT party,votes,RANK() OVER(ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000024' and yr = 2017
ORDER BY party;
```
3. Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1).
```sql
SELECT yr,party,votes,RANK() OVER(PARTITION BY yr ASC ORDER by votes DESC) AS posn
FROM ge
WHERE constituency = 'S14000021'
ORDER BY party,yr
```
4. Edinburgh constituencies are numbered S14000021 to S14000026.
Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency.
```sql
SELECT constituency,party,votes, RANK() OVER(PARTITION BY constituency  ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
AND yr = 2017
ORDER BY 4,1
```
5. Show the parties that won for each Edinburgh constituency in 2017.
```sql
SELECT constituency, party
FROM (SELECT DISTINCT constituency, party, 
           RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
    FROM ge
    WHERE yr = 2017 AND constituency BETWEEN 'S14000021' AND 'S14000026'
) AS winners
WHERE posn = 1;
```
6. Show how many seats for each party in Scotland in 2017. Scottish constituencies start with 'S'
```sql
SELECT party , COUNT(*)
FROM ge x
WHERE constituency like 'S%'
AND yr = 2017 AND votes >= ALL(SELECT votes FROM ge y WHERE x.constituency = y. constituency AND y.yr = 2017)
GROUP BY party
```
