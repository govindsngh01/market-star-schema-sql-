use  market_star_schema;
SELECT * FROM demo_schema.sales;

-- 1. Customer with Highest Average Discount.
select 
    cd.Cust_id,
    cd.Customer_Name,
    round(avg(mf.Discount),2) as Avg_Discounte
from  market_fact_full as mf
join cust_dimen as cd on  mf.Cust_id = cd.Cust_id
group by cd.Cust_id, cd.Customer_Name
order by Avg_Discount desc
limit 1; 


-- 2. Top 5 most profitable products.
select
    pd.product_sub_category,
    sum(mf.sales) as revenue,
    sum(mf.profit) as profit,
    round(sum(mf.profit) / nullif(sum(mf.sales), 0) * 100, 2) as profit_margin_percent
from market_fact_full as mf
join prod_dimen as pd on mf.prod_id = pd.prod_id
group by pd.product_sub_category
order by profit desc
limit 5;


-- 3. city with highest sales.
select
    cd.city,
    sum(mf.sales) as total_sales
from market_fact_full as mf
join cust_dimen as cd on mf.cust_id = cd.cust_id
group by cd.city
order by total_sales desc;


-- 4. Top 10 customers for 80% profit.
with customerprofit as (
    select cust_id, sum(profit) as profit
    from market_fact_full
    group by cust_id
),
cumulative as (
    select 
        cust_id, profit,
        sum(profit) over (order by profit desc) as cum_profit,
        sum(profit) over () as total_profit
    from customerprofit
)
select 
    cd.cust_id, cd.customer_name, cu.profit
from cumulative as cu
join cust_dimen as cd on cu.cust_id = cd.cust_id
where cu.cum_profit <= cu.total_profit * 0.8
limit 10;

-- 5. Create a profit category:
 -- Profit > 1000      High Profit
 -- Profit 500-1000    Medium Profit
  -- Else               Low Profit

select 
  cust_id , Profit, Product_Category,
case 
when Profit > 1000 then 'high profit'
when Profit between 500 and 1000 then 'Medium profit'
else 'low profit'
end as profit_category
from market_fact_full as mf join prod_dimen as pd 
on mf.Prod_id=pd.Prod_id;

-- 6. shipping mode efficiency and delivery time.
select
    sd.ship_mode,
    count(*) as total_shipments,
    avg(datediff(sd.ship_date, od.Order_date)) as avg_delivery_days,
    sum(mf.shipping_cost) as total_shipping_cost,
    sum(mf.profit) as total_profit,
    round(sum(mf.profit) / nullif(sum(mf.shipping_cost), 0), 2) as profit_per_shipping_cost
from market_fact_full as mf
join shipping_dimen as sd on mf.ship_id = sd.ship_id
join orders_dimen as od on od.Ord_id = mf.Ord_id
group by sd.ship_mode
order by profit_per_shipping_cost desc;

-- 7. discount impact on profit
select
    case 
        when mf.discount = 0 then 'no discount'
        when mf.discount <= 0.1 then '0-10%'
        when mf.discount <= 0.2 then '10-20%'
        else '20%+'
    end as discount_bracket,
    count(*) as order_count,
    avg(mf.profit) as avg_profit,
    round(avg(mf.profit) / nullif(avg(mf.sales), 0) * 100, 2) as avg_profit_margin
from market_fact_full as mf
group by discount_bracket
order by avg_profit asc;

-- 8. month-over-month sales growth using lag()

with monthlysales as (
    select 
        date_format(Order_date, '%y-%m') as month,
        sum(sales) as total_sales
    from market_fact_full as mf join orders_dimen as od  
    on mf.Ord_id = od.Ord_id
    group by date_format(Order_date, '%y-%m')
)
select 
    month,
    total_sales,
    lag(total_sales) over (order by month) as prev_month_sales,
    round(((total_sales - lag(total_sales) over (order by month)) 
           / nullif(lag(total_sales) over (order by month), 0)) * 100, 2) as mom_growth_percent
from monthlysales;


-- 9. running total and 3-month moving average
select
    date_format(order_date, '%y-%m') as month,
    sum(sales) as monthly_sales,
    sum(sum(sales)) over (order by date_format(order_date, '%y-%m')) as running_total,
    avg(sum(sales)) over (order by date_format(order_date, '%y-%m') 
                          rows between 2 preceding and current row) as moving_avg_3m
from market_fact_full as mf join orders_dimen as od  
    on mf.Ord_id = od.Ord_id
group by date_format(order_date, '%y-%m')
order by month;

-- 10. rank products within category by profit
select
    pd.product_category,
    pd.product_sub_category,
    sum(mf.profit) as profit,
    rank() over (partition by pd.product_category order by sum(mf.profit) desc) as rank_in_category
from market_fact_full as mf
join prod_dimen as pd on mf.prod_id = pd.prod_id
group by pd.product_category, pd.product_sub_category
order by pd.product_category, rank_in_category;

-- 11. state-wise profit margin analysis
select
    cd.state,
    sum(mf.sales) as total_sales,
    sum(mf.profit) as total_profit,
    round(sum(mf.profit) / nullif(sum(mf.sales), 0) * 100, 2) as profit_margin,
    sum(mf.order_quantity) as total_quantity
from market_fact_full as mf
join cust_dimen as cd on mf.cust_id = cd.cust_id
group by cd.state
having sum(mf.sales) > 10000
order by profit_margin desc;

-- 12. loss making products
select
    pd.product_sub_category,
    sum(mf.order_quantity) as units_sold,
    sum(mf.profit) as total_loss,
    count(*) as order_count
from market_fact_full as mf
join prod_dimen as pd on mf.prod_id = pd.prod_id
where mf.profit < 0
group by pd.product_sub_category
order by total_loss asc
limit 10;

-- 13. high discount but negative profit orders
select
    mf.Ord_id,
    pd.product_sub_category,
    mf.discount,
    mf.sales,
    mf.profit
from market_fact_full as mf
join cust_dimen as cd on mf.cust_id = cd.cust_id
join prod_dimen as pd on mf.prod_id = pd.prod_id
where mf.discount > 0.15 and mf.profit < 0
order by mf.profit asc
limit 10;

-- 14. Find the customer who generated the highest sale.  

With CustomerSales as (
    select 
        Cust_id,
        sum(sales) as total_Sales,
        ROW_NUMBER() OVER (order by sum(sales) desc) as rnk
    from market_fact_full
    group by cust_id
)
select  cust_id, total_Sales
from CustomerSales
where rnk = 1;


-- 15. customers with sales above overall average
with customersales as (
    select cust_id, sum(sales) as total_sales
    from market_fact_full
    group by cust_id
)
select
    cs.cust_id, cd.customer_name, cs.total_sales
from customersales as cs
join cust_dimen as cd on cs.cust_id = cd.cust_id
where cs.total_sales > (select avg(total_sales) from customersales)
order by cs.total_sales desc;
