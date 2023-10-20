/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1


/* Q2: Which countries have the most Invoices? */

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


/* Q3: What are top 3 values of total invoice? */

SELECT total 
FROM invoice
ORDER BY total DESC


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

-- Method 1
select cu.email, cu.first_name, cu.last_name
from customer as cu, genre as ge
where ge.name = 'Rock'
order by email;
-- Method 2
select cus.email, cus.first_name, cus.last_name
from invoice inv join customer cus
on inv.customer_id = cus.customer_id
join invoice_line il on inv.invoice_id = il.invoice_id
join track tr on tr.track_id = il.track_id
join genre as gen on gen.genre_id = tr.genre_id
where gen.name like 'Rock'
order by email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select ar.name,count(ar.artist_id) as number_of_songs
from track tr join genre gen
on tr.genre_id = gen.genre_id
join album al on al.album_id = tr.album_id
join artist ar on ar.artist_id = al.artist_id
where gen.name like 'Rock'
group by ar.artist_id 
order by number_of_songs desc limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

select * from customer;
select * from genre;
select * from invoice;
select * from invoice_line;
select * from track;
select * from artist;
select * from album;
select * from media_type;


WITH best_selling_artist AS(
	select ar.artist_id as artist_id, ar.name as artist_name, sum(il.unit_price*il.quantity) as total_sales
	from invoice_line il join track tr
	on tr.track_id = il.track_id join album al
	on al.album_id = tr.album_id join artist ar
	on ar.artist_id = al.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
sum(il.unit_price*il.quantity) as total_sales
from invoice inv join customer c
on c.customer_id = inv.customer_id join invoice_line il
on il.invoice_id = inv.invoice_id join track tr
on tr.track_id = il.track_id join album al
on al.album_id = tr.album_id join best_selling_artist as bsa
on bsa.artist_id = al.artist_id
group by 1, 2, 3, 4
order by 5 desc;













