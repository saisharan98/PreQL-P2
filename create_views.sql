-- create views

-- View: customer_monthly_sales_2019_view
-- i. Customer id, customer last name, customer first name, year, month, aggregate
-- total amount of all products purchased by month for 2019.

create or replace view customer_monthly_sales_2019_view as
select c.customerid, c.lastname, c.firstname, res.cyear, res.cmonth, res.cprice
    from customers c,
    (select s.customerid as cid, year(s.salesdate) as cyear, month(s.salesdate) as cmonth, sum(p.price*s.quantity) as cprice
        from sales s, products p
        where s.productid = p.productid
        and year(s.salesdate) = 2019
        group by s.customerid, year(s.salesdate), month(s.salesdate)) res
    where c.customerid = res.cid;
    
-- query the view to verify it
select * from customer_monthly_sales_2019_view;

-- View: top_ten_customers_amount_view
-- i. Customer id, customer last name, customer first name, total lifetime purchased
-- amount
-- ii. This view should only return the top ten customers sorted by total dollar amount
-- in sales from highest to lowest.

create or replace view top_ten_customers_amount_view as
select c.customerid, c.lastname, c.firstname, res.cprice
    from customers c,
    (select s.customerid as cid, sum(p.price*s.quantity) as cprice
        from sales s, products p
        where s.productid = p.productid
        group by s.customerid
        order by sum(p.price*s.quantity) desc
        limit 10) res
    where c.customerid = res.cid
    order by res.cprice desc;
    
-- query the view to verify it
select * from top_ten_customers_amount_view;
    
-- An alternative way of doing it using dense_rank

-- select c.customerid, c.lastname, c.firstname, res.cprice
--     from customers c,
--     (select s.customerid as cid, sum(p.price*s.quantity) as cprice, dense_rank() over (order by sum(p.price*s.quantity) desc) drank
--         from sales s, products p
--         where s.productid = p.productid
--         group by s.customerid) res
--     where c.customerid = res.cid
--     and res.drank <= 10
--     order by res.drank;


-- View: product_sales_view
-- i. Create a Snowflake product and sales view that includes columns for sales year
-- and month.
-- ii. OrderID, SalesPerson ID, Customer ID, Product ID, Product Name, Product
-- Price, Quantity, Total Sales Amount, Order Date, Sales Year, Sales Month

create or replace view product_sales_view as
select s.orderid, s.salespersonid, s.customerid, s.productid, p.name, p.price, s.quantity, p.price*s.quantity totalsales, date(s.salesdate) date, year(s.salesdate) year, month(s.salesdate) month
    from sales s, products p
    where s.productid = p.productid;
    
-- query the view to verify it
select * from product_sales_view;
