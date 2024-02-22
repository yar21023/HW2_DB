/*создаем таблицы*/
create  table customers( 
customer_id  integer PRIMARY KEY,
first_name text,
last_name text,
gender text,
DOB varchar(10),
job_title text,
job_industry_category text,
wealth_segment text,
deceased_indicator text, 
owns_car text,
address text,
postcode integer,
state text,
country text,
property_valuation integer
)

create  table transactions( 
transaction_id integer PRIMARY KEY,
product_id integer,
customer_id integer,
transaction_date varchar(10),
online_order bool,
order_status text,
brand text,
product_line text,
product_class text,
product_size text,
list_price float(4),
standard_cost float(4)
)

/*Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов. */
select distinct brand  from transactions  
	where standard_cost > 1500
	
/*Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно. */
select transaction_id, transaction_date, order_status  from transactions 
	where order_status = 'Approved' and (transaction_date::date between'2017-04-01' and '2017-04-09')
	order by transaction_date
	
/*Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'. */
select distinct  job_title from customers 
	where job_title like 'Senior%' and job_industry_category in ('IT','Financial Services')
	
/*Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services */
select distinct brand 
	from transactions t inner join customers c on t.customer_id = c.customer_id  
	where c.job_industry_category = 'Financial Services' and t.brand is not null and t.brand != ''
	
/*Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'. */
select  c.customer_id, c.first_name, c.last_name, t.brand, t.online_order  
	from  transactions t full outer join customers c on t.customer_id = c.customer_id 
	where t.brand in  ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')  and t.online_order  
	limit 10
	
/*Вывести всех клиентов, у которых нет транзакций. */
select c.customer_id, c.first_name, c.last_name, t.transaction_date 
	from  transactions t right join customers c on t.customer_id = c.customer_id 
	where t.customer_id is null 
	
/*Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью. */
select distinct  c.customer_id, c.first_name, c.last_name, c.job_industry_category, t.standard_cost  
	from  transactions t left join customers c on t.customer_id = c.customer_id
	where c.job_industry_category = 'IT' and t.standard_cost = (select max(standard_cost) from transactions)
	
/*Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'. */	
select c.customer_id, c.first_name, c.last_name, c.job_industry_category, t.order_status, t.transaction_date  
	from  transactions t full outer join customers c on c.customer_id = t.customer_id 
	where c.job_industry_category in ('IT', 'Health') and t.order_status = 'Approved' and 
     (t.transaction_date::date between  '2017-07-07' and '2017-07-17')
     order by t.transaction_date 
