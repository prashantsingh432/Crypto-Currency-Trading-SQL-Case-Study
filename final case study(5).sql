SELECT * FROM trading.members;
SELECT * FROM trading.transactions;
SELECT * FROM trading.prices;



-- Now that we've tackled a more complicated series of questions - let's take it to the next level!
-- In these final questions - we will try to assess the profitability of our mentors and their crypto portfolios.
--  we  have  to see the various prices for every transaction that occured, calculate the total fee amounts and also calculate some final profit metrics.


-- we will analyze 3 strategy in this case study

       #1 Buy and hold (HODL Strategy)
       #2 Buy and keep buying (Bull Strategy)
	   #3 Buy and sell (Trader Strategy)
-- - we will cover each strategy by simplifying our existing trading.transactions table to answer more questions!




#1 Buy and Hold Analysis >>>>>>>>>>>>>>>>>>>>>>

-- Meet lois - she is our mentor who will take the buy and hold strategy otherwise known as the "HODL strategy" or hold on for dear life!
-- She is risk averse and just wants to leave her initial investment alone because she believes her original holdings will grow over time with low risk.


lois's Transaction History
She purchases 50 BTC and 50 ETH on Jan 1st 2017
She holds onto all of her portfolio and does not sell anything (HODL)
She also does not purchase any additional quantity of either crypto
By August 29th 2021 (the last date of our price data) - we can assess her individual performance


-- For this simplified scenario - we first need to create a new temp table called leah_hodl_strategy using the code below:

CREATE TABLE lois_hodl_strategy (
    txn_id INT,
    member_id VARCHAR(10),
    ticker VARCHAR(10),
    txn_date DATE,
    txn_type VARCHAR(10),
    quantity INT,
    percentage_fee DECIMAL(5,2),
    txn_time DATETIME
);

INSERT INTO lois_hodl_strategy (txn_id, member_id, ticker, txn_date, txn_type, quantity, percentage_fee, txn_time)
VALUES
    (12, 'c20ad4', 'BTC', '2017-01-01', 'BUY', 50, 0.30, '2017-01-01 00:00:00'),
    (26, 'c20ad4', 'ETH', '2017-01-01', 'BUY', 50, 0.30, '2017-01-01 00:00:00');
    
    
    
    
    SELECT * FROM trading.lois_hodl_strategy;
    
    
    
    
    
    
    
    
    
    
    
Question 1 
We can calculate - 
The initial value of her original 50 BTC and 50 ETH purchases
The dollar amount of fees she paid for those 2 transactions
    
    
select  sum(l.quantity * p.price) as initial_value,
		sum(l.quantity * p.price * l.percentage_fee / 100) as fees
 from  lois_hodl_strategy l 
join prices p on l.ticker = p.ticker and l.txn_date = p.market_date;



Question 2
The final value of her portfolio on August 29th 2021


select 
sum( l.quantity * p.price) as final_value

 from lois_hodl_strategy l
join prices p on p.ticker = l.ticker
where p.market_date ='2021-08-29'



Question 3
Calculate the profitability by dividing lois's final value by initial value


with cte as(

select 
#initial_value
    sum(l.quantity * p1.price) as initial_value,
    sum(l.quantity * p1.price * l.percentage_fee/ 100) as fees,
    
#final_value

sum(l.quantity * p2.price) as final_value
from lois_hodl_strategy l
join prices p1 on p1.ticker = l.ticker and p1.market_date = l.txn_date
join prices p2 on p2.ticker = p1.ticker
where p2.market_date = '2021-08-29')

select initial_value, fees,  final_value / initial_value as profitability
 from cte
 
 











#2. The Bull Strategy>>>>>>>>>>>>>>>>>>>>

Vikram is also similar to Leah but purchases Bitcoin frequently because he believes the price will go up in the future!

Vikram's Transaction History
Vikram also purchases 50 units of both ETH and BTC just like Leah on Jan 1st 2017
He continues to purchase more throughout the entire 4 year period
He does not sell any of his crypto - he's in it for the long run


Vikram's Data
Because this is also a simplified version of our dataset - 

CREATE TABLE vikram_bull_strategy (
    txn_id INT,
    member_id VARCHAR(10),
    ticker VARCHAR(10),
    txn_date DATE,
    txn_type VARCHAR(10),
    quantity DECIMAL(18, 14),
    percentage_fee DECIMAL(5, 2),
    txn_time DATETIME
);

INSERT INTO vikram_bull_strategy (txn_id, member_id, ticker, txn_date, txn_type, quantity, percentage_fee, txn_time)
VALUES
    (11, '6512bd', 'BTC', '2017-01-01', 'BUY', 50, 0.30, '2017-01-01 00:00:00'),
    (25, '6512bd', 'ETH', '2017-01-01', 'BUY', 50, 0.30, '2017-01-01 00:00:00'),
    (30, '6512bd', 'ETH', '2017-01-01', 'BUY', 8.84298701787532, 0.30, '2017-01-01 06:22:20.202995'),
    (31, '6512bd', 'BTC', '2017-01-01', 'BUY', 2.27106258645779, 0.21, '2017-01-01 06:40:48.691577'),
    (35, '6512bd', 'BTC', '2017-01-01', 'BUY', 6.73841780964583, 0.30, '2017-01-01 11:00:14.002519'),
    (36, '6512bd', 'BTC', '2017-01-01', 'BUY', 9.37875791241961, 0.30, '2017-01-01 12:03:33.017453'),
    (55, '6512bd', 'BTC', '2017-01-02', 'BUY', 5.54383811940401, 0.30, '2017-01-02 11:12:42.895079'),
    (63, '6512bd', 'ETH', '2017-01-02', 'BUY', 5.04372609654009, 0.07, '2017-01-02 20:48:13.480413'),
    (65, '6512bd', 'BTC', '2017-01-02', 'BUY', 3.01276029896716, 0.30, '2017-01-02 21:00:49.341793'),
    (99, '6512bd', 'ETH', '2017-01-04', 'BUY', 1.83100404691078, 0.30, '2017-01-04 22:04:12.689306');
    
    
    
    
Required Metrics
To assess Vikram's performance we also need to regularly match the prices for his trades throughout the 4 years and not just at the start of the entire dataset, like in the case of Leah's HODL strategy.

We will need to calculate the following metrics:

-- Total investment amount in dollars for all of his purchases
-- The dollar amount of fees paid
-- The dollar cost average per unit of BTC and ETH purchased by Vikram
-- The final investment value of his portfolio on August 29th 2021
-- Profitability can be measured by final portfolio value divided by the investment amount
-- Profitability split by BTC and ETH





Question 1
Calculate the total investment amount in dollars for all of Vikram's purchases and his dollar amount of fees paid


select 
 sum(v.quantity * p.price) as initial_investment,
 sum(v.quantity * p.price * v.percentage_fee / 100) as fees
 from vikram_bull_strategy v
join prices p on p.ticker = v.ticker and p.market_date = v.txn_date





#Question 2
#What is the average cost per unit of BTC and ETH purchased by Vikram

WITH cte AS (
    SELECT v.ticker,
           SUM(v.quantity) AS total_quantity,
           SUM(v.quantity * p.price) AS initial_investment
    FROM vikram_bull_strategy v
    INNER JOIN prices p ON p.ticker = v.ticker AND p.market_date = v.txn_date
    GROUP BY v.ticker
)
SELECT ticker, initial_investment / total_quantity AS avg_dollar_cost
FROM cte
order by avg_dollar_cost desc








#Question 4
-- Calculate profitability by using final portfolio value divided by the investment amount


WITH cte AS (
    SELECT 
           SUM(v.quantity * p.price) AS initial_investment,
		   SUM(v.quantity * p2.price) AS final_value
    FROM vikram_bull_strategy v
    INNER JOIN prices p ON p.ticker = v.ticker AND p.market_date = v.txn_date
	INNER JOIN prices p2 ON p2.ticker = v.ticker 
	WHERE p2.market_date = '2021-08-29')
    
 select final_value / initial_investment AS profitability
FROM cte

--------------------------------------------------------------------------------------------------------------------------------------------------
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--------------------------------------------------------------------------------------------------------------------------------------------------















#3. The Trader Strategy........................


#Nandita is the Queen of crypto trading - she wants to follow the popular trader's adage of BUY LOW, SELL HIGH

#Nandita's Transaction History>>>


She also starts out with a 50 BTC and ETH purchase just like Leah and Vikram
She continues to buy more crypto over the 4 years
She starts selling some of her crypto portfolio to realise gains

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE nandita_trading_strategy (
    txn_id INT,
    member_id VARCHAR(255),
    ticker VARCHAR(255),
    txn_date DATE,
    txn_type VARCHAR(255),
    quantity DECIMAL(18, 8),
    percentage_fee DECIMAL(18, 8),
    txn_time DATETIME
);

INSERT INTO nandita_trading_strategy (txn_id, member_id, ticker, txn_date, txn_type, quantity, percentage_fee, txn_time)
VALUES
    (3, 'a87ff6', 'BTC', '2017-01-01', 'BUY', 50, 0.00, '2017-01-01 00:00:00'),
    (19, 'a87ff6', 'ETH', '2017-01-01', 'BUY', 50, 0.20, '2017-01-01 00:00:00'),
    (41, 'a87ff6', 'ETH', '2017-01-01', 'BUY', 1.98666102, 0.30, '2017-01-01 17:39:10.894181'),
    (49, 'a87ff6', 'ETH', '2017-01-02', 'BUY', 8.78673521, 0.30, '2017-01-02 04:48:50.044665'),
    (53, 'a87ff6', 'BTC', '2017-01-02', 'BUY', 5.95980482, 0.30, '2017-01-02 09:55:27.347188'),
    (60, 'a87ff6', 'BTC', '2017-01-02', 'BUY', 9.01117723, 0.30, '2017-01-02 17:16:29.062839'),
    (64, 'a87ff6', 'ETH', '2017-01-02', 'BUY', 1.37715908, 0.01, '2017-01-02 20:49:33.771818'),
    (77, 'a87ff6', 'BTC', '2017-01-03', 'BUY', 3.80769454, 0.30, '2017-01-03 12:30:20.779105'),
    (89, 'a87ff6', 'BTC', '2017-01-04', 'BUY', 5.68677207, 0.00, '2017-01-04 08:13:07.752195'),
    (93, 'a87ff6', 'BTC', '2017-01-04', 'BUY', 8.13772500, 0.30, '2017-01-04 12:25:48.367139');
    
    
    
    
    
    #We can calculate>
-- Count of buy and sell transactions
-- Total investment amount of purchases
-- The dollar amount of fees for purchase transactions
-- Dollar cost average of purchases
-- Total gross revenue of sell transactions
-- Average sell price for each unit sold
-- Final portfolio value and quantity
-- Profitability measured as (final portfolio value + gross sales revenue - purchase fees - sales fees) / initial investment amount




#Question 1
-- Calculate Nandita's purchase metrics for each of her BTC and ETH portfolios:
-- ticker,
--   purchase_count,
--   purchase_quantity,
--   initial_investment,
--   purchase_fees,
--   dollar_cost_average



with cte as(
select n.ticker,
	   count(*) as purchase_count,
       sum(n.quantity) as purchase_quantity,
       sum(n.quantity * p.price) as initial_investment,
       sum(n.quantity * p.price * n.percentage_fee / 100) as purchase_fees
 from nandita_trading_strategy n
join prices p on p.ticker = n.ticker and p.market_date = n.txn_date
where n.txn_type = 'buy'
group by n.ticker)


select *, initial_investment / purchase_quantity AS avg_dollar_cost from cte

    
    
    
    
    
#Question 2
-- Calculate Nandita's sales metrics for each of her BTC and ETH portfolios:

-- Count of sales transactions
-- Gross revenue amount
-- Sales fees
-- Average selling price
    
    
with cte as(
select n.ticker,
	   count(*) as sales_count,
       sum(n.quantity) as  sales_quantity,
       sum(n.quantity * p.price) as gross_revenue ,
       sum(n.quantity * p.price * n.percentage_fee / 100) as sales_fees
 from nandita_trading_strategy n
join prices p on p.ticker = n.ticker and p.market_date = n.txn_date
where n.txn_type =  'SELL'
group by n.ticker)
select *,gross_revenue / sales_quantity AS average_selling_price from cte








#Question 3
-- What is Nandita's final BTC and ETH portfolio value and quantity?

with cte as (
select  member_id, txn_date, txn_type, ticker, percentage_fee,
	case
        when txn_type = 'BUY' then quantity
        when txn_type = 'sell' then -quantity
        end as quantity 
from nandita_trading_strategy)

select cte.ticker,
	   sum(cte.quantity) as final_quantity,
       sum(cte.quantity * p.price) AS final_portfolio_value
 from cte 
join prices p on p.ticker = cte.ticker
where p.market_date = '2021-08-29'
group by cte.ticker







