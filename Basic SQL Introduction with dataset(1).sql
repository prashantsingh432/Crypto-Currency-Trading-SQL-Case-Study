SELECT * FROM trading.members;
SELECT * FROM trading.transactions;
SELECT * FROM trading.prices;



#Question 1
-- Show only the top 5 rows from the trading.members table

select * from members
limit 5



#Question 2
-- Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows

Select * from members
order by first_name asc
limit 3


#Question 3
-- Which records from trading.members are from the United States region?

select * from members
where region = 'United states'




#Question 5
-- Return the unique region values from the trading.members table and sort the output by reverse alphabetical order

select distinct region from members
order by region desc



#Question 6
-- How many mentors are there from Australia or the United States?
select count(*) as total_mentor from members
where region = 'Australia' or region = 'United States'

-- or 


SELECT
  COUNT(*) AS mentor_count
FROM trading.members
WHERE region IN ('Australia', 'United States');




#Question 7
-- How many mentors are there per region? Sort the output by regions with the most mentors to the least


select region,  count(*)  n_mentor from members
group by region
order by region desc




