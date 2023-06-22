SELECT * FROM trading.members;
SELECT * FROM trading.transactions;
SELECT * FROM trading.prices;


#Question 1
-- How many records are there in the trading.transactions table?

select * from transactions




#Question 2
-- How many unique transactions are there?


select count(distinct txn_id)  as unique_t 
from transactions




#Question 3
-- How many buy and sell transactions are there for Bitcoin?

select txn_type , count(*) as total_transactions
 from transactions
 where ticker = 'BTC'
 group by 1
 





#Question 4
-- For each year, calculate the following buy and sell metrics for Bitcoin:

-- total transaction count
-- total quantity
-- average quantity per transaction
-- Also round the quantity columns to 2 decimal places.

SELECT YEAR(txn_time) AS txn_year,
       txn_type,
       ROUND(COUNT(*)) AS trans_count,
       ROUND(SUM(quantity), 2) AS Total_quantity,
       ROUND(AVG(quantity), 2) AS avg_quantity
FROM transactions
WHERE ticker = 'BTC'
GROUP BY txn_year, txn_type
ORDER BY txn_type;








#Question 5
-- Summarise all buy and sell transactions for each member_id by generating 1 row for each member with the following additional columns:

-- Bitcoin buy quantity
-- Bitcoin sell quantity
-- Ethereum buy quantity
-- Ethereum sell quantity



select member_id,
   sum(case when ticker = 'BTC' and txn_type = 'buy' then quantity else 0 end) as Bitcoin_buy_quantity,
   sum(case when ticker = 'BTC' and txn_type = 'sell' then quantity else 0 end) as Bitcoin_sell_quantity,
   
   sum(case when ticker = 'ETH' and txn_type = 'buy' then quantity else 0 end) as Ethereum__buy_quantity,
   sum(case when ticker = 'ETH' and txn_type = 'sell' then quantity else 0 end) as Ethereum__sell_quantity
   
from transactions
group by member_id






#Question 6

SELECT * FROM trading.transactions;
-- Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least

SELECT member_id, SUM(quantity) AS btc_sold_quantity
FROM  transactions
WHERE ticker = 'BTC' AND txn_type = 'SELL'
GROUP BY member_id
HAVING SUM(quantity) < 500
ORDER BY btc_sold_quantity DESC;


#lets try to solve this question with CTE

with cte as (

select member_id, sum(quantity) as btc_sold_quantity
from transactions
where ticker = 'BTC' and txn_type = 'sell'
group by member_id)

select * from cte 
where btc_sold_quantity <500
order by btc_sold_quantity desc






#Question 7
-- Which member_id has the highest buy to sell ratio by quantity?

select member_id,
		sum(case when txn_type = 'buy' then quantity else 0 end) / 
        sum(case when txn_type = 'sell' then quantity else 0 end) as buy_to_sell_ratio
from transactions
group by 1
order by buy_to_sell_ratio desc







#Question 1
#Question 1