# END TO END BAKERY SALES ANALYSIS PROJECT

![ProjectArchitecure](asset/Architecure.png)
This end-to-end data engineering project extracts a dataset from Kaggle via API, processes it for cleanliness, and loads it into PostgreSQL using SQLAlchemy for query-level analysis. Optimized with schema design and indexing, the data is then connected to Power BI for interactive visualizations and insights. 

## Project Goal
- Implement a full Data Engineering and Analysis cycle to analyse a yearly total sales report from the given data
- Extract the data from kaggle using kaggle API, transform and clean the extracted data, and then load to postgreSQL and connect to Power BI.
- Answer the given question in SQL and deliver the end visualized report.

## Tech Stack
- Python
- Kaggle
- PostgreSQL
- PowerBI
- SQLAlchemy

## Pipeline Process
For Full Documentation, Check : **[Main](project.ipynb)**

`Use kaggle API to download dataset`
```python 
pip install kaggle
kaggle datasets download -d hosubjeong/bakery-sales
```
`open dataset zipfile`
```python
zip_path = 'bakery-sales.zip'

with zipfile.ZipFile('bakery-sales.zip','r') as file :
    file.extractall('bakery_sales') 

extract_foler = 'bakery_sales'
csv_files = [f for f in os.listdir(extract_foler) if f.endswith('.csv')]

df1 = pd.read_csv(os.path.join(extract_foler, csv_files[0]))
df2 = pd.read_csv(os.path.join(extract_foler, csv_files[1]))
```
`Save and load cleaned dataset to PostgreSQL`
```python
clean_df.to_csv('bakery_sales/bakery_sales_cleaned.csv')
engine = create_engine('postgresql+psycopg2://name:pass@hostname/database')
clean_df.to_sql('sales',engine, if_exists='replace',index=False)
```
After this the dataset will loaded at postgreSQL with the table named (sales) :

| Name    | Type  | 
| :-------------- | :------- | 
| `id`       | `SERIAL`| 
| `year` | `VARCHAR(20)` |      
| `month`       | `VARCHAR(20)`| 
| `day_of_week` | `VARCHAR(20)` |        
| `buy_hour`       | `TIME`| 
| `place` | `VARCHAR(20)` |        
| `total_items`       | `INT`| 
| `angbutter` | `INT` |        
| `plain_bread`       | `INT`| 
| `americano` | `INT` |        
| `croissant`       | `INT`| 
| `caffe_latte` | `INT` |   
| `tiramisu_croissant` | `INT` |        
| `cacao_deep`       | `INT`| 
| `pain_au_chocolat` | `INT` |     
| `almond_croissant` | `INT` |        
| `croque_monsieur`       | `INT`| 
| `mad_garlic` | `INT` |     
| `milk_tea` | `INT` |    
| `getau_chocolat` | `INT` |     
| `pandoro` | `INT` |    
| `cheese_cake` | `INT` |     
        
## Query Analysis
For full documentation, please check : **[SQL file](Query.sql)**
1. Question : What is the total revenue for each month?
```sql
SELECT 
	year, month, SUM(total) as Revenue
FROM
	sales
GROUP BY 
	year, month
ORDER BY
	 year, month;
```
|  year |  month | revenue |
| :----- | :------| :----- |
| `2019` | `August` | `6082020` |
| `2019` | `December` | `4964340` |
| `2019` | `July` | `2810220` |
| `2019` | `November` | `4527360` |
| `2019` | `October` | `3942440` |
| `2019` | `September` | `4873760` |
| `2020` | `April` | `4883680` |
| `2020` | `February` | `6405940` |
| `2020` | `January` | `4492140` |
| `2020` | `June` | `18500` |
| `2020` | `March` | `6445100` |
| `2020` | `May` | `308400` |

2. Question : Compare weekday vs. weekend sales performance.
```sql
WITH weekday_sales AS(
	SELECT 
		ROUND(AVG(total)::numeric,2) as average_weekday_sales
	FROM
		sales
	WHERE 
		day_of_week IN ('Mon','Tues','Wed','Thur','Fri')
),

weekend_sales AS(
	SELECT 
		ROUND(AVG(total)::numeric,2) as average_weekend_sales
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

```
|  average_weekday_sales |  average_weekend_sales |
| :----- | :------|
| `20773.79` | `20239.82`

3. What are the peak sales hours during the day?
```SQL
SELECT 
	buy_hour, ROUND(AVG(total_items),0) AS average_item_sold
FROM
	sales
GROUP BY
	buy_hour
ORDER BY
	average_item_sold DESC
LIMIT 3;
```
|  buy_hour | average_item_sold |
| :----- | :------|
| `23:00:00` | `7` |
| `13:00:00` | `4` |
| `15:00:00` | `4` |

## Visualization Report

![2019Report](asset/2019Report.png)
![2019Report](asset/2020Report.png)
