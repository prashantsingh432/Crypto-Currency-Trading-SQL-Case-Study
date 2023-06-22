SELECT * FROM trading.members;
SELECT * FROM trading.transactions;
SELECT * FROM trading.prices;



-- Data Analysis begin>>>>>>>>>>>>>>>

-- Now that we've explored all 3 of our tables - 
-- let's try to first visualize how each of the tables 
-- are joined onto eachother using an Entity Relationship Diagram or ERD for short!	


#Analyse the Ranges
#Firstly - let's see what is the range of data we have to play with!




#Question 1
-- What is the earliest and latest date of transactions for all members?


SELECT
  MIN(date(txn_time)) AS earliest_date,
  MAX(date(txn_time)) AS latest_date
FROM trading.transactions;






#Question 1
#What is the range of market_date values available in the prices data?

SELECT
  MIN(market_date) AS earliest_date,
  MAX(market_date) AS latest_date
FROM prices;









#Joining our Datasets
-- Now that we now our date ranges are from January 2017 through to almost the end of August 2021 for both our prices
--  and transactions datasets - we can now get started on joining these two tables together!


-- Let's make use of our ERD shown above to combine the trading.transactions table 
-- and the trading.members table to answer a few simple questions about our mentors!



#Question 3
-- Which top 3 mentors have the most Bitcoin quantity as of the 29th of August?

select m.first_name, 
	sum(case 
			when t.txn_type = 'buy' then t.quantity
		    when t.txn_type = 'sell' then -t.quantity
            end) as total_quantity
from transactions t
inner join members m 
on t.member_id = m.member_id
where  ticker = 'BTC'
group by m.first_name
order by total_quantity desc
limit 3













#Calculating Portfolio Value
-- Now let's combine all 3 tables together using only strictly INNER JOIN so we can utilise all of our datasets together.




#Question 4
-- What is total value of all Ethereum portfolios for each region at the end date of our analysis? Order the output by descending portfolio value

with cte as (
select ticker, price from prices
where ticker= 'ETH' and market_date = '2021-08-29')

select m.region,
		sum(case
			    when t.txn_type = 'buy' then t.quantity
                when t.txn_type = 'sell' then -t.quantity 
			end) * cte.price as avg_eth_value
		,avg(case
			    when t.txn_type = 'buy' then t.quantity
                when t.txn_type = 'sell' then -t.quantity 
			end) * cte.price as avg_eth_value
from transactions t 
inner join  cte on t.ticker = cte.ticker
inner join members m on t.member_id = m.member_id
where t.ticker = 'eth'
group by m.region , cte.price
order by  avg_eth_value desc       










#Question 5
-- What is the average value of each Ethereum portfolio in each region? Sort this output in descending order

with cte as (
select ticker, price from prices
where ticker = 'ETH' and market_date = '2021-08-29')

select m.region, 
		avg( case
				 when t.txn_type = 'buy' then t.quantity
                 when t.txn_type  = 'sell' then-t.quantity
                 end) * cte.price as avg_eth_value
from transactions t
inner join cte 		   on t.ticker = cte.ticker
inner join members m   on  t.member_id = m.member_id

where t.ticker = 'ETH'
group by m.region , cte.price
order by avg_eth_value desc














