/*  --------------------------------------------------------------
--   Please fill in your information in this comment block --
--   Section: 2
--   Group:   1
--   Student ID: 6388030, 6388035, 6388040, 63880127
--   Business Domain: Entertainment/Movies (Major Cineplex)
------------------------------------------------------------- */

USE `major`;

-- BASIC QUERY BELOW -- 

-- Q1: Which tickets are Honeymoon seats?
SELECT ticket_ID AS "Ticket ID", seat.seat_ID AS "Seat ID", seat_type AS "Type", seat_price AS "Price"
  FROM ticket
  INNER JOIN seat ON seat.seat_id = ticket.seat_id
  WHERE seat.seat_type = "Honeymoon"
  ORDER BY ticket_id ASC;

-- Query 2: Show every movie ID, date, and time that would be in theater 3 and ascending order by date. <>
SELECT `movie_ID` AS `Movie Name`, `date` AS `Date`, `time` AS `Time`
   FROM `showtime`
   WHERE `theater_ID` = 3
   ORDER BY `date` ASC, `time` ASC;

-- Query 3: Show how much each customer has lost their money in pursuit of temporary happiness, happiest at the top. <>
SELECT customer_email AS `Customer Email`, SUM(price) as `Amount Spent`
    FROM `ticket`
    GROUP BY customer_email
    ORDER BY `Amount Spent` DESC;
    
-- Query 4: Show top 3 month that have the most showtime. <>
SELECT month(`date`) as `Month`, count(*) as `No of Show` 
    FROM `showtime`
    GROUP BY month(`date`)
    ORDER BY `No of Show` DESC, `month` DESC
    LIMIT 3;
    
-- Query 5: Show the amount of customers that use gmail are like cultured civilized people. <>
SELECT COUNT(`email`) as `Cultured gmail user`
    FROM `customer`
    WHERE `email` REGEXP '@gmail\.com';

-- Query 6: Lists customers that are more than 18 years of age (For age restriction purposes)
SELECT CONCAT(first_name," ",last_name) AS 'Customer Name', YEAR(CURDATE())-YEAR(birthdate) AS Age
  FROM registered_customer
  WHERE YEAR(CURDATE())-YEAR(birthdate) > 18  -- Cannot use alias in WHERE, only in HAVING
  ORDER BY YEAR(CURDATE())-YEAR(birthdate) DESC;

-- Query 7: Display all the customer fullname and card numbers that has expired
SELECT CONCAT(first_name," ",last_name) AS 'Expired card',card_number AS "Card Number", expiry_date AS "Expired On"
  FROM card
  WHERE DATEDIFF(expiry_date,CURDATE()) < 0;
  
-- Query 8: Calculate how many dates are left for all customer cards and print out the customer fullname with the left date
SELECT CONCAT(first_name," ",last_name) AS 'Name', DATEDIFF(expiry_date,CURDATE()) AS "Date left"
  FROM card
  WHERE DATEDIFF(expiry_date,CURDATE()) > 0
  ORDER BY DATEDIFF(expiry_date,CURDATE()) DESC;

-- Query 9: Show the ticket that has been sold on a special discount day (Wednesday) and print out the ticket ID along with day bought and email who bought it.
SELECT ticket_ID AS "Ticket ID", `date` AS "Day bought", customer_email AS "Associated Email"
  FROM ticket
  WHERE  WEEKDAY(date)=2;
  
-- Query 10: Count how many customers are in the database groupped by type (registed or not)
SELECT customer_type AS "Type", COUNT(*) AS "Amount of Customer"
  FROM customer
  GROUP BY customer_type;

-- Query 11: Show all of the seat in the theater 5 theater ID and order by the highest price
SELECT *
		FROM seat
		WHERE theater_id = 5
		ORDER BY seat_price DESC;

-- Query 12: Find the name of the movie that have movie_length more than 120 and have English soundtrack
SELECT movie_name,movie_system
		FROM MOVIE
		WHERE movie_length > 120 AND soundtrack = "EN";

-- Query 13: Find theater ID that are 2D medium size
SELECT `theater_ID` AS `Theater ID`, `size` AS `Size`
		FROM theater
		WHERE `size` = "M" AND `showing_system` = "2D";

-- Query 14: Count movies by genre and print out the genre that has the number of movies more than 1
SELECT movie_genre AS `Movie Genre`, count(*) AS `No of Movie`
		FROM movie
		WHERE movie_rate < 18
		GROUP BY `Movie Genre`
		HAVING count(*) > 1;

-- Query 15: Find how many customers who write the description when they rated the movie
SELECT COUNT(rating_ID) AS `Rating with description`
		FROM rating
		WHERE description IS NOT NULL;
		
-- Query 16: Find each religion of registered customer that has more than 1 religion and order by the maximum religion
SELECT religion AS `Religion`, COUNT(email) AS `No of religion`
		FROM registered_customer
		GROUP BY religion
		HAVING `No of religion` > 1
		ORDER BY `No of religion` DESC;

-- Query 17: Find all of the sold ticket price in year 2021
SELECT YEAR(date) AS `Year`, SUM(price) AS `Total price`
		FROM ticket
		WHERE YEAR(date) = 2021;

-- Query 18: List every movie names that released on this year (2021) and ordered by the movie name alphabetically.
SELECT movie_name AS `Movie Name`, movie_system, IF (ISNULL(subtitle), soundtrack, CONCAT(soundtrack,"/",subtitle)) AS `Dub/Sub`
		FROM movie
		WHERE YEAR(release_date) = 2021
		ORDER BY `Movie Name` ASC;

-- Query 19: Number of the tickets bought by each customer including total price.
SELECT customer_email, count(*) AS `Tickets bought`, sum(price) `Total price`
    FROM ticket
	  WHERE YEAR(DATE) = YEAR(CURDATE())
    GROUP BY customer_email
    ORDER BY `Total price` DESC;


-- Query 20: Find the movie name in action genre that's longer than 2 hours and order by the movie name alphabetically (Beware of some movies that has more than 1 system)
SELECT DISTINCT movie_name AS `Movie Name`
		FROM movie
		WHERE movie_length > 120 AND movie_genre = "Action"
		ORDER BY movie_name ASC;

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- ADVANCE QUERY -- 

-- Q1: List all movies(movie name, movie genre and rating score) that have the rating_score > 2.5
SELECT movie_name AS `Movie Name`, movie_genre AS `Movie Genre`, rating_score AS `Rating Score`
FROM movie m
INNER JOIN Rating r ON m.movie_ID = r.movie_ID
GROUP BY m.movie_ID
HAVING `rating_score` > 2.5
ORDER BY `Rating Score` DESC;

-- Q2: List all customer names(first and last name) and how many times does a customer watch a movie ordered by the least watching time.
SELECT CONCAT(first_name, " ", last_name) AS `Customer Name`, COUNT(email) AS `Watch Time`
		FROM customer c
		INNER JOIN ticket t ON c.email = t.customer_email
		GROUP BY customer_email
		ORDER BY `Watch Time` ASC;

-- Q3: How many ticket for each movie ordered by the amount of ticket(ticket join showtime join movie, count ticket group by movie_name)<>
SELECT `movie`.movie_name AS `Movie Name`, COUNT(*) AS `Ticket Count`
    FROM `ticket`
    INNER JOIN `showtime` ON `ticket`.showtime_ID = `showtime`.showtime_ID
    INNER JOIN `movie`    ON `showtime`.movie_ID = `movie`.movie_ID
    GROUP BY `Movie Name`
    ORDER BY `Ticket Count` DESC;
    
-- Q4: Number of showtimes in a month and ordered by the maximum showtime
SELECT s.showtime_ID AS `Showtime ID`, COUNT(t.showtime_ID) AS `No of Showtime`
		FROM showtime s
		INNER JOIN ticket t ON t.showtime_ID = s.showtime_ID
		GROUP BY s.showtime_ID
		ORDER BY `No of Showtime` DESC;

-- Q5: Number of registered customers that live in the same district as the Theater
SELECT COUNT(rc.district) AS `Customer district` FROM registered_customer_address rc
		WHERE rc.district IN
		(SELECT DISTINCT ba.district AS `Branch district` FROM branch_address ba);

-- Q6: Find out which customer bought less than average number of ticket so you can email them to buy more <>
SELECT  `Customer Email`, `Ticket Bought`
   FROM(
		 SELECT customer_email AS `Customer Email`, COUNT(*) as `Ticket Bought`
        FROM `ticket`
        GROUP BY customer_email) AS `T`
   			WHERE `Ticket Bought` < (SELECT AVG(`Ticket Bought`)
   FROM(
		 SELECT customer_email AS `Customer Email`, COUNT(*) as `Ticket Bought`
        FROM `ticket`
        GROUP BY customer_email) AS `TT`)
ORDER BY `Ticket Bought` DESC;
    
-- Q7: Number of showtimes for 2D, 3D, 4D movies.
SELECT movie_system AS `Movie System`, count(*) AS `No of System`
    FROM showtime s
    JOIN movie m ON m.movie_id = s.movie_id
    GROUP BY movie_system ORDER BY `No of System` DESC;

-- Q8: List the movies with the most tickets sold during 2018.
SELECT movie_name AS `Movie`, COUNT(t.ticket_ID) AS `Amount of tickets bought`
	FROM ticket t
	INNER JOIN showtime sh ON sh.showtime_ID = t.showtime_ID
  LEFT OUTER JOIN movie m ON sh.movie_ID = m.movie_ID
  GROUP BY m.movie_ID
  ORDER BY `Amount of tickets bought` DESC;

-- Q9: Customer that has bought more than 3 tickets this year
SELECT CONCAT(first_name, " ", last_name) AS `Customer Name`,email, COUNT(Ticket_ID) AS "Amount of tickets bought this year"
  FROM customer c
  INNER JOIN ticket t ON c.email = t.customer_email
  WHERE YEAR(date)-YEAR(CURDATE())=0
  GROUP BY email
  HAVING COUNT(Ticket_ID) > 3;

-- Q10: Generate a showtime schedule of theater 3 ([movie_name, date, time] showtime join movie copy basQ3)
SELECT `movie`.movie_name, `date`, `time`
    FROM `showtime`
    INNER JOIN `movie` ON `showtime`.movie_ID = `movie`.movie_ID
    WHERE theater_ID = 3
    ORDER BY `date` ASC, `time` ASC;  

-- Q11: Movie genre that people watch the most (Descending Order)
SELECT movie_genre AS `Movie Genre`, count(*) AS `No of Customer`
    FROM ticket t
    JOIN showtime s ON s.showtime_ID = t.showtime_ID
    JOIN movie m ON s.movie_id = m.movie_id
    GROUP BY movie_genre ORDER BY `No of Customer` DESC;

-- Q12: Show which theater is most frequented (join something)
SELECT DISTINCT (t.theater_ID) AS `Theater ID`, COUNT(t.theater_ID) AS `Count theater`
		FROM theater t
		INNER JOIN showtime s ON t.theater_ID = s.theater_ID
		INNER JOIN ticket tic ON tic.showtime_ID = s.showtime_ID
		GROUP BY t.theater_ID
		ORDER BY `Count theater` DESC
		LIMIT 1;

-- Q13: Number of tickets sold for each soundtrack group with average rating
SELECT m.soundtrack, count(*) AS `Number of tickets sold`, `Average` AS `Average rating` FROM ticket t
JOIN showtime st ON t.showtime_id = st.showtime_id
JOIN movie m ON st.movie_id = m.movie_id
LEFT JOIN (
	SELECT mm.soundtrack, avg(r.rating_score) AS `Average` FROM movie mm
    JOIN rating r ON r.movie_id = mm.movie_id
    GROUP BY mm.soundtrack
) AS rat 
ON rat.soundtrack = m.soundtrack
GROUP BY m.soundtrack ORDER BY `Number of tickets sold` DESC;

-- Q14: Show the most popular showtime period (Descending).
SELECT DISTINCT s.time AS `Time`, COUNT(t.time) AS `Count`
		FROM showtime s
		INNER JOIN ticket t ON s.showtime_ID = t.showtime_ID
		GROUP BY s.time
		ORDER BY `Count` DESC;

-- Q15: Number of seats and showtimes in each theater order by number of showtimes in descending order.
SELECT t.theater_ID AS `Theater ID`, count(DISTINCT(seat_id)) AS `Number of seats`, COALESCE(`Number of showtimes`,0) AS `Number of showtimes`
FROM theater t
JOIN seat s ON t.theater_id = s.theater_id
LEFT JOIN
(SELECT tt.theater_id, COUNT(*) AS `Number of showtimes` FROM theater tt
   		JOIN showtime st ON st.theater_id = tt.theater_id
   		GROUP BY tt.theater_id) AS temp
ON t.theater_id = temp.theater_id
GROUP BY t.theater_id ORDER BY `Number of showtimes` DESC;

-- Q16: How many branches that's located in Bangkok and the district begin with 'Bang'
SELECT count(b.branch_ID) AS `Count Branch ID`
		FROM branch b
		INNER JOIN branch_address ba ON ba.branch_ID = b.branch_ID
		WHERE city = 'Bangkok' AND district LIKE "Bang%";

-- Q17: Select movie_id, movie_name, movie_system, Dub/Sub, Average rating, theater id, and showtime of the movie that have average rating of more than 3.5 ordered by rating in descending order. 
SELECT DISTINCT m.movie_id AS `Movie ID`, movie_name AS `Movie Name`, movie_system, IF (ISNULL(subtitle), soundtrack, CONCAT(soundtrack,"/",subtitle)) AS `Dub/Sub`, `Average Rating`, theater_id AS `Theater ID`, s.date, s.time FROM showtime s
JOIN movie m on s.movie_id = m.movie_id
JOIN rating r ON s.movie_id = r.movie_id
JOIN
    (SELECT mm.movie_id, avg(rating_score) as `Average Rating` FROM rating rr
  		JOIN movie mm ON rr.movie_id = mm.movie_id
   		GROUP BY mm.movie_id) AS rm
ON rm.movie_id = s.movie_id
WHERE `Average Rating` > 3.5
ORDER BY date, time ASC;

-- Q18: First name and last name of the customers for each occupied seat
SELECT Ticket_ID, CONCAT(c.first_name, " ", c.last_name) AS `Customer Name`, seat_ID AS "Assigned seat", theater_id AS "Theater", t.date AS "Date", t.time AS "Showtime"
  FROM customer c
  INNER JOIN ticket t ON c.email = t.customer_email
  INNER JOIN customer ca ON ca.email = c.email
  INNER JOIN showtime s ON t.showtime_id = s.showtime_id
  ORDER BY Ticket_ID ASC;

-- Q19: Show movie statistics (Movie Name, avg rating, ticket sold, and ticket sold)
SELECT movie_name AS "Movie Name", movie_system AS "System", AVG(rating_score) AS "Average rating", COUNT(DISTINCT(t.ticket_ID)) AS "Tickets sold"
	FROM movie m
	LEFT OUTER JOIN rating r ON m.movie_id = r.movie_id 
  LEFT OUTER JOIN showtime s ON m.movie_id = s.movie_id 
	LEFT OUTER JOIN ticket t ON s.showtime_ID = t.showtime_ID 
	GROUP BY m.movie_ID
	ORDER BY AVG(rating_score) DESC;

-- Q20: Show tickets that were bought with cards 
SELECT Ticket_ID, CONCAT(c.first_name, " ", c.last_name) AS `Customer Name`, seat_ID AS "Assigned seat", theater_id AS "Theater", t.time AS "Showtime", ca.card_number AS "Card number used"
  FROM customer c
  INNER JOIN ticket t ON c.email = t.customer_email
  INNER JOIN card ca ON ca.email = c.email
  INNER JOIN showtime s ON t.showtime_id = s.showtime_id
  ORDER BY Ticket_ID ASC;

-- * -- * -- * -- * END OF SQL SCRIPT =) * -- * -- * -- * -- * --