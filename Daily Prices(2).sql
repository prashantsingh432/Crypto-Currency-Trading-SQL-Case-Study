SELECT * FROM trading.members;
SELECT * FROM trading.transactions;
SELECT * FROM trading.prices;


#Bitcoin price data and  Ethereum price data>

select * from prices
where ticker = 'BTC' 
limit 3                         #bitcoine price



select * from prices
where ticker = 'ETH'
limit 3 					   #Ethereum price














#Data Exploration>>>>>>>

#Question 1
-- How many total records do we have in the trading.prices table?
select count(*) from prices



#Question 2
-- How many records are there per ticker value?

SELECT ticker, COUNT(ticker) AS record_count
FROM trading.prices
GROUP BY ticker;




#Question 3
-- What is the minimum and maximum market_date values?

select min(market_date) as minimum ,
 max(market_date) as max 
 from prices






#Question 4
-- Are there differences in the minimum and maximum market_date values for each ticker?

select ticker,  min(market_date) as minimum , 
max(market_date) as max 
from prices
group by ticker





#Question 5
-- What is the average of the price column for Bitcoin records during the year 2020?

select avg(price) as avg_price  from prices
where ticker = 'BTC' and
 market_date between '2020-01-01' and '2020-12-31'
 group by ticker
 
 
 
 
 
 #Question 6
-- What is the monthly average of the price column for Ethereum in 2020?
-- Sort the output in chronological order and also round the average price value to 2 decimal places


SELECT
  month(market_date) AS month_start,
  -- need to cast approx. floats to exact numeric types for round!
  ROUND(AVG(price), 2) AS average_eth_price
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
  AND ticker = 'ETH'
GROUP BY month_start
ORDER BY month_start;




#Question 8
-- How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?

select count(high) as high_price_count
from prices
where ticker = 'BTC' and high > 30000






#Question 9
-- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?

SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days
FROM trading.prices
WHERE YEAR( market_date) = '2020-01-01'
GROUP BY ticker;


