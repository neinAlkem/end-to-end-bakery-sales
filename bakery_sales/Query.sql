--Create Table Sales
CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	year VARCHAR(20),
	month VARCHAR(20),
	day_of_week VARCHAR(20),
	buy_hour TIME,
	place VARCHAR(20),
	total_items INT,
	total INT,
	angbutter INT,
	plain_bread INT,
	jam INT,
	americano INT,
	croissant INT,
	caffe_latte INT,
	tiramisu_croissant INT,
	cacao_deep INT,
	pain_au_chocolat INT,
	almond_croissant INT,
	croque_monsieur INT,
	mad_garlic INT,
	milk_tea INT,
	getau_chocolat INT,
	pandoro INT,
	cheese_cake INT
)
	
--Checking Tables
SELECT * FROM sales;

--What is the total revenue for each month?
SELECT 
	year, month, SUM(total) as Revenue
FROM
	sales
GROUP BY 
	year, month
ORDER BY
	 year, month;

--What is the average daily sales revenue?
SELECT 
	ROUND(AVG(total),2) as daily_revenue_sales
FROM
	sales;

--Compare weekday vs. weekend sales performance.
WITH weekday_sales AS(
	SELECT 
		ROUND(AVG(total),2) as average_weekday_sales
	FROM
		sales
	WHERE 
		day_of_week IN ('Mon','Tues','Wed','Thur','Fri')
),

weekend_sales AS(
		SELECT 
		ROUND(AVG(total),2) as average_weekend_sales
	FROM
		sales
	WHERE 
		day_of_week IN ('Sat','Sun')
) 
	
SELECT
	weekday_sales.average_weekday_sales,
	weekend_sales.average_weekend_sales
FROM 
	weekday_sales
CROSS JOIN
	weekend_sales


--Who are the top 3 customer original place?
SELECT
	place, sum(total) as total_revenue
FROM
	sales
GROUP BY
	place
HAVING
	place NOT IN('Other')
ORDER BY
	total_revenue DESC
LIMIT 3

--What is the most frequently purchased item?
WITH total_item_sold AS(
		SELECT 'angbutter' as item, angbutter as total_sold from sales
		UNION ALL
		SELECT 'plain_bread' ,plain_bread from sales
		UNION ALL
		SELECT 'jam', jam from sales
		UNION ALL
		SELECT 'americano', americano from sales
		UNION ALL
		SELECT 'croissant' , croissant from sales
		UNION ALL	
		SELECT 'tiramisu_croissant' , tiramisu_croissant from sales
		UNION ALL
		SELECT 'cacao_deep', cacao_deep from sales
		UNION ALL
		SELECT 'pain_au_chocolat' , pain_au_chocolat from sales
		UNION ALL
		SELECT 'almond_croissant', almond_croissant from sales
		UNION ALL
		SELECT 'croque_monsieur', croque_monsieur from sales
		UNION ALL
		SELECT 'mad_garlic' , mad_garlic from sales
		UNION ALL
		SELECT 'milk_tea', milk_tea from sales
		UNION ALL
		SELECT 'getau_chocolat' , getau_chocolat from sales
		UNION ALL
		SELECT 'cheese_cake', cheese_cake from sales
	)

SELECT 
	item, sum(total_sold) as total_sold
FROM
	total_item_sold
GROUP BY
		item
ORDER BY
	total_sold DESC
LIMIT 5;

--Identify any product that has not been sold or under 50 total sold.
WITH total_item_sold AS(
		SELECT 'angbutter' as item, angbutter as total_sold from sales
		UNION ALL
		SELECT 'plain_bread' ,plain_bread from sales
		UNION ALL
		SELECT 'jam', jam from sales
		UNION ALL
		SELECT 'americano', americano from sales
		UNION ALL
		SELECT 'croissant' , croissant from sales
		UNION ALL	
		SELECT 'tiramisu_croissant' , tiramisu_croissant from sales
		UNION ALL
		SELECT 'cacao_deep', cacao_deep from sales
		UNION ALL
		SELECT 'pain_au_chocolat' , pain_au_chocolat from sales
		UNION ALL
		SELECT 'almond_croissant', almond_croissant from sales
		UNION ALL
		SELECT 'croque_monsieur', croque_monsieur from sales
		UNION ALL
		SELECT 'mad_garlic' , mad_garlic from sales
		UNION ALL
		SELECT 'milk_tea', milk_tea from sales
		UNION ALL
		SELECT 'getau_chocolat' , getau_chocolat from sales
		UNION ALL
		SELECT 'cheese_cake', cheese_cake from sales
	)
	
SELECT 
	item, sum(total_sold) as total_sold
FROM
	total_item_sold
GROUP BY
	item
HAVING
	SUM(total_sold) < 50
ORDER BY
	total_sold ASC
LIMIT 5;

--What are the peak sales hours during the day?
SELECT 
	buy_hour, ROUND(AVG(total_items),0) AS average_item_sold
FROM
	sales
GROUP BY
	buy_hour
ORDER BY
	average_item_sold DESC
LIMIT 3;

--On which day of the week does the bakery generate the most revenue?
SELECT 
	day_of_week, sum(total) as total_revenue
FROM
	sales
GROUP BY
	day_of_week
HAVING
	day_of_week NOT IN('Not Recorded')
ORDER BY 
	total_revenue DESC;


--WHAT IS YoY total revenue ?

WITH yearly_revenue AS(
	SELECT 
		year, SUM(total) as revenue
	FROM
		sales
	GROUP BY
		year
	HAVING 
		year IN ('2019', '2020')
)

SELECT 
	y2019.revenue as revenue_2019,
	y2020.revenue as revenue_2020,
	ROUND(((y2020.revenue - y2019.revenue)/ y2019.revenue) * 100,2) AS YoY_Growth
FROM yearly_revenue y2019
JOIN yearly_revenue y2020
	ON y2019.year = '2019' AND y2020.year = '2020';

