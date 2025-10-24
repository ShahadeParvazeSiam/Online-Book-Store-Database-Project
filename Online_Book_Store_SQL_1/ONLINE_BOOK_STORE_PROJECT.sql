-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM customers;
SELECT * FROM orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE genre = 'Fiction';

-- 2) Find books published after the year 2000:
SELECT * FROM Books 
WHERE published_year > 2000;

-- 3) List all customers from the Canada:
SELECT * FROM customers 
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS TOTAL_STOCK FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 7 quantity of a book:
SELECT * FROM orders 
WHERE quantity>7;

-- 8) Retrieve all orders where the total amount exceeds $100:
SELECT * FROM Orders 
WHERE total_amount>100;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM orders;

-- Advance Questions : 

-- 12) Retrieve the total number of books sold for each genre:
SELECT b.genre , SUM(o.quantity) AS total_book_sold
FROM Books b
JOIN 
orders o
ON 
b.book_id = o.book_id
GROUP BY genre ;

-- 13) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS AVG_PRICE 
FROM Books
WHERE genre = 'Fantasy';

-- 14) List customers who have placed at least 5 orders:
SELECT c.customer_id , c.name , count (o.order_id) AS COUNT_ORDER
FROM customers c
JOIN 
orders o 
ON 
c.customer_id = o.customer_id 
GROUP BY c.customer_id , c.name
HAVING count (o.order_id) >= 5 ; 

-- 15) Find the most frequently ordered book:
SELECT b.book_id, b.title, b.author, COUNT (o.order_id) AS count_book
FROM Books b
JOIN 
orders o 
ON 
b.book_id = o.book_id 
GROUP BY b.book_id, b.title, b.author
ORDER BY count_book DESC LIMIT 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT title, author, genre, price 
FROM Books 
WHERE genre = 'Fantasy'
ORDER BY  price DESC LIMIT 3; 

-- 17) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS TOTAL_SOLD
FROM Books b 
JOIN 
orders o 
ON 
b.book_id = o.book_id 
GROUP BY b.author
ORDER BY TOTAL_SOLD DESC;

-- 18) List the cities where customers who spent over $300 are located:
SELECT c.name, c.city, c.country, SUM(o.total_amount) AS TOTAL_SPEND
FROM customers c
JOIN 
orders o 
ON 
c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.name, c.city, c.country
HAVING SUM(o.total_amount) > 300 
ORDER BY TOTAL_SPEND DESC ; 

-- 19) Find the customer who spent the most on orders:
SELECT c.name, SUM(o.total_amount) AS TOTAL_SPEND
FROM customers c
JOIN 
orders o 
ON 
c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.name
ORDER BY TOTAL_SPEND DESC LIMIT 1 ;


--20) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS total_order, 
       b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_quantity
FROM Books b 
LEFT JOIN
orders o 
ON 
b.book_id = o.book_id
GROUP BY b.book_id,b.title, b.stock
ORDER BY b.book_id;


-- 21) Find the books which is out of stock 
-- same as 20 , just use HAVING 
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS total_order, 
       b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_quantity
FROM Books b 
LEFT JOIN
orders o 
ON 
b.book_id = o.book_id 
GROUP BY b.book_id,b.title, b.stock
HAVING b.stock - COALESCE(SUM(o.quantity), 0) <= 0
ORDER BY b.book_id;



	   








