SELECT 
  continent, name, area 
FROM 
  world AS x
WHERE 
  area >= ALL (
  SELECT 
    area 
  FROM 
    world AS y
  WHERE 
    y.continent = x.continent
  AND 
    area > 0
  )
  
  SELECT 
    name, continent, population 
  FROM 
    world
  WHERE 
    name 
  IN (
    SELECT 
      name
    FROM 
      world x
    WHERE 
      population < ALL (
        SELECT
          population
        FROM
          world y
        WHERE
          y.continent = x.continent
        AND
          population < 250000000
        )
    )
    
    # 7 from SELECT within SELECT tutorial
    WHERE 250000000 > ALL (
      SELECT
        population
      FROM
        ...
    )
    
    #countries/names
    #continents
    
    #skiped 7 & 8 from SELECT within SELECT Tutorial
    SELECT
      continent
    FROM 
      world
    WHERE name
    ALL name IN (    
      SELECT
        name
      FROM
        world
      WHERE
        population < 25000000
    )
    
    SUM and COUNT
    #1
    SELECT SUM(population)
    FROM world
    
    # 2
    SELECT DISTINCT continent
    FROM world
    
    #3
    SELECT 
      sum(gdp) 
    FROM 
      world 
    WHERE
      continent = "Africa"
      
    #4
    SELECT 
      COUNT(name)
    FROM
      world
    WHERE
      area > 1000000
    
    #5
    SELECT
      SUM(population)
    FROM
      world
    WHERE
      name in ('France','Germany','Spain') 
      
    #6
    SELECT
      continent, count(name)
    FROM
      world
    GROUP BY
      continent
      
    #7
    SELECT 
      continent, count(name) 
    FROM
     world
    WHERE
     population >= 10000000
    GROUP BY 
      continent
      
    #The JOIN operation
    
    #1
    SELECT matchid, player 
    FROM goal 
    WHERE teamid = 'GER'
    
    #2
    SELECT id, stadium, team1, team2
    FROM game 
    WHERE id = 1012
    
    #3
    SELECT player, teamid, mdate
    FROM game JOIN goal ON (id=matchid)
    WHERE teamid = 'GER'
    
    #4
    SELECT team1, team2, player
    FROM game JOIN goal ON (id=matchid)
    WHERE player LIKE 'Mario%'
    
    #5
    SELECT player, teamid, coach, gtime
    FROM goal JOIN eteam on teamid=id 
    WHERE gtime<=10
    
    #6
    SELECT mdate, teamname
    FROM game JOIN eteam ON (team1 = eteam.id)
    WHERE eteam.coach = "Fernando Santos"
    
    #7
    SELECT player
    FROM goal JOIN game on (matchid = id)
    WHERE stadium = "National Stadium, Warsaw"
    
    #8
    SELECT DISTINCT player
    FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER') AND teamid != 'GER'
    
    #9
    SELECT teamname, count(matchid)
    FROM eteam JOIN goal ON id = teamid
    GROUP BY teamname
    
    #10
    SELECT stadium, COUNT(matchid)
    FROM game JOIN goal ON matchid = id
    GROUP BY stadium
    
    #11
    SELECT matchid, mdate, count(matchid)
    FROM game JOIN goal ON matchid = id 
    WHERE (team1 = 'POL' OR team2 = 'POL')
    GROUP BY matchid
    
    #12
    SELECT matchid, mdate, count(matchid)
    FROM game JOIN goal ON matchid = id
    WHERE teamid = 'GER'
    GROUP BY matchid
    
    #13
    -- skipped this question (go back to later)
    
    #More JOIN operations
    
    #2
    SELECT yr
    FROM movie
    WHERE title = 'Citizen Kane'
    
    #3
    SELECT id, title, yr
    FROM movie
    WHERE title LIKE "%Star Trek%"
    ORDER BY yr
    
    #4
    SELECT title
    FROM movie
    WHERE id IN (11768, 11955, 21191)
    
    #5
    SELECT id
    FROM actor
    WHERE name = "Glenn Close"
    
    #6
    SELECT id
    FROM movie
    WHERE title = 'Casablanca'
    
    #7
    SELECT name
    FROM actor JOIN casting ON (id = actorid)
    WHERE movieid = 11768
    
    #8
    SELECT name
    FROM actor JOIN casting ON (id = actorid)
    WHERE movieid = ( 
      SELECT id 
      FROM movie 
      WHERE title = 'Alien')
      
    #9
    SELECT title
    FROM movie JOIN casting ON (id = movieid)
    WHERE actorid = ( 
      SELECT id 
      FROM actor 
      WHERE name = 'Harrison Ford')
      
    #10
    SELECT title
    FROM movie JOIN casting ON (id = movieid)
    WHERE actorid = ( 
      SELECT id 
      FROM actor 
      WHERE name = 'Harrison Ford') 
    AND ord != 1
    
    #11
    SELECT title, name
    FROM movie 
      JOIN casting ON (id = movieid)
      JOIN actor ON (actorid = actor.id)
    WHERE yr = 1962 AND ord = 1
    
    #12
    SELECT yr, COUNT(title) 
    FROM movie 
      JOIN casting ON movie.id = movieid
      JOIN actor   ON actorid = actor.id
    WHERE name='John Travolta'
    GROUP BY yr
    HAVING COUNT(title)=(SELECT MAX(c) FROM
    (SELECT yr,COUNT(title) AS c FROM
       movie JOIN casting ON movie.id=movieid
             JOIN actor   ON actorid=actor.id
     WHERE name='John Travolta'
     GROUP BY yr) AS t
    )
    
    
    #13
    SELECT title, name, yr
    FROM  movie JOIN casting ON movie.id = movieid
      JOIN actor ON actorid = actor.id 
    WHERE movieid IN (SELECT movieid
    FROM casting JOIN actor ON (actorid = actor.id)
    WHERE name = 'Julie Andrews') AND casting.ord = 1
    
    #14
    SELECT name
    FROM actor JOIN casting ON id = actorid
    WHERE ord = 1 
    GROUP BY name
    HAVING COUNT(name) >= 30
    ORDER BY name
    
    #15 
    SELECT title, count(title)
    FROM movie 
      JOIN casting ON (id = movieid)
      JOIN actor ON (actor.id = actorid)
    WHERE yr = 1978
    GROUP BY title
    ORDER BY count(actorid) DESC
    
    #16
    SELECT DISTINCT name
    FROM actor JOIN casting ON actorid = actor.id
    WHERE movieid IN (
    SELECT movieid
    FROM actor JOIN casting ON actorid = actor.id
    WHERE name = "Art Garfunkel"
    ) AND name != "Art Garfunkel"
    
    
    #Using Null
    
    #1
    SELECT name
    FROM teacher
    WHERE dept IS NULL
    
    #2
    SELECT teacher.name, dept.name
    FROM teacher INNER JOIN dept
    ON (teacher.dept=dept.id)
    
    #3
    SELECT teacher.name, dept.name
    FROM teacher LEFT OUTER JOIN dept
    ON (teacher.dept = dept.id)
    
    #4
    SELECT teacher.name, dept.name
    FROM teacher RIGHT OUTER JOIN dept
    ON (teacher.dept = dept.id)
    
    #5
    SELECT name, COALESCE(mobile, '07986 444 2266') AS mobile
    FROM teacher
    
    #6
    SELECT teacher.name, COALESCE(dept.name, 'None') AS dept
    FROM teacher LEFT OUTER JOIN dept ON teacher.dept = dept.id
    
    #7
    SELECT COUNT(name), COUNT(mobile)
    FROM teacher
    
    #8
    SELECT dept.name, COUNT(teacher.name)
    FROM teacher RIGHT JOIN dept ON dept.id = teacher.dept
    GROUP BY dept.name
    
    #9
    SELECT teacher.name, 
      CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
      ELSE 'Art'
      END
    FROM teacher
    
    #10
    SELECT teacher.name, 
      CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
      WHEN dept = 3 THEN 'Art'
      ELSE 'None'
      END
    FROM teacher
    
    #NSS Tutorial
    #1
    SELECT A_STRONGLY_AGREE
      FROM nss
     WHERE question='Q01'
       AND institution='Edinburgh Napier University'
       AND subject='(8) Computer Science'
       
     #2
     SELECT institution, subject
       FROM nss
      WHERE question='Q15'
        AND score >= 100
        
      #3
      SELECT institution,score
        FROM nss
       WHERE question='Q15'
         AND score < 50
         AND subject='(8) Computer Science'
         
       #4
       SELECT subject, sum(response)
         FROM nss
        WHERE question='Q22'
        AND subject in ('(8) Computer Science', '(H) Creative Arts and Design')
       GROUP BY subject
       
       #5
       SELECT subject,  sum(response * A_STRONGLY_AGREE / 100)
         FROM nss
       WHERE question='Q22'
          AND subject in ('(8) Computer Science', '(H) Creative Arts and Design')
       GROUP BY subject
       
       #6
       SELECT subject,  ROUND(SUM(A_STRONGLY_AGREE * response/100) / SUM(response / 100))
       FROM nss
       WHERE question='Q22'
       AND subject in ('(8) Computer Science', '(H) Creative Arts and Design')
       GROUP BY subject
       
       #7
       SELECT institution, ROUND(SUM(score * response) / SUM(response), 0)
       FROM nss
       WHERE question='Q22'
       AND (institution LIKE '%Manchester%')
       GROUP BY institution
       
       #8
       #return to finish when done
       CREATE VIEW [comp_table] AS
       SELECT institution, SUM(sample) AS comp
       FROM nss
       WHERE question='Q01' AND subject LIKE '%(8)%'
          AND (institution LIKE '%Manchester%')
       GROUP BY institution

       SELECT institution, SUM(sample)
       FROM nss RIGHT JOIN comp_table
       WHERE question='Q01' AND subject LIKE '%(8)%'
          AND (institution LIKE '%Manchester%')
       GROUP BY institution
       
       #self join
       #1
       SELECT COUNT(id)
       FROM stops
    
       #2
       SELECT id
       FROM stops
       WHERE name = 'Craiglockhart'
       
       #3
       SELECT id, name
       FROM stops JOIN route ON id = stop
       WHERE num = '4' AND company ='LRT'
       
       #4
       SELECT company, num, COUNT(*)
       FROM route WHERE stop=149 OR stop=53
       GROUP BY company, num
       
       # 5
       SELECT a.company, a.num, a.stop, b.stop
       FROM route a JOIN route b ON
         (a.company=b.company AND a.num=b.num)
       WHERE a.stop=53 AND b.stop = (
         SELECT id 
         FROM stops
         WHERE name = 'London Road')
        
       # 6
       SELECT a.company, a.num, stopa.name, stopb.name
       FROM route a JOIN route b ON
         (a.company=b.company AND a.num=b.num)
         JOIN stops stopa ON (a.stop=stopa.id)
         JOIN stops stopb ON (b.stop=stopb.id)
       WHERE stopa.name='Craiglockhart' AND stopb.name = "London Road"
       
       #7
       SELECT DISTINCT a.company, a.num
       FROM route a JOIN route b ON
         (a.company=b.company AND a.num=b.num)
         JOIN stops stopa ON (a.stop=stopa.id)
         JOIN stops stopb ON (b.stop=stopb.id)
       WHERE stopa.name='Haymarket' AND stopb.name = 'Leith'
       
       #8
       SELECT DISTINCT a.company, a.num
       FROM route a JOIN route b ON
         (a.company=b.company AND a.num=b.num)
         JOIN stops stopa ON (a.stop=stopa.id)
         JOIN stops stopb ON (b.stop=stopb.id)
       WHERE stopa.name='Craiglockhart' AND stopb.name = 'Tollcross'   
       
       #9
       SELECT DISTINCT stopb.name, a.company, a.num
       FROM route a JOIN route b ON
         (a.company=b.company AND a.num=b.num)
         JOIN stops stopa ON (a.stop=stopa.id)
         JOIN stops stopb ON (b.stop=stopb.id)
       WHERE stopa.name='Craiglockhart'
       
       #10
       SELECT a.company, a.num, a.stop, b.stop, c.stop
       FROM route a JOIN route b ON
        (a.company = b.company AND a.num = b.num)
        JOIN route c ON (b.company = c.company AND b.num = c.num)
        JOIN stops stopa ON (a.stop = stopa.id)
        JOIN stops stopb ON (b.stop = stopb.id)
        JOIN stops stopc ON (c.stop = stopc.id)
       WHERE stopa.name='Craiglockhart' AND stopc.name = 'Sighthill'
       
	   #10 (SOLUTION)
	   SELECT DISTINCT
	     a.num, b.company, transfer.name, d.num, d.company 
	   FROM route a
	   JOIN route b
	   ON a.num = b.num AND a.company = b.company
	   JOIN route c
	   ON c.stop = b.stop
	   JOIN route d
	   ON
	   c.num = d.num AND c.company = d.company
	   JOIN stops start ON start.id = a.stop
	   JOIN stops transfer ON c.stop = transfer.id
	   JOIN stops end ON end.id = d.stop
	   WHERE start.name = "Craiglockhart"
	   AND end.name = "Sighthill"
	   ORDER BY start.name