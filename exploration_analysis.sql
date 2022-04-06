-- environment setup
use role sysadmin;
use warehouse compute_wh;
use database preql_sales;
use schema raw;

-- ############################
-- '''Sales Table Analysis'''
-- ############################

-- no duplicate orderids
select orderid, count(*) from sales
    group by orderid
    having count(*) > 1;

-- checking if there are duplicate rows in sales
select count(*), salespersonid, customerid, productid, quantity, salesdate
    from sales
    group by salespersonid, customerid, productid, quantity, salesdate
    having count(*) > 1;

-- sanity check for these specific records
select *
    from sales
    where salespersonid = 11 and customerid = 16080 and productid = 370 and quantity = 875 and salesdate = timestamp_from_parts(2019, 04, 13, 23, 02, 27);

-- ~50% of orders have quantity = productid
select count(*) / (select count(*) from sales) as precent_equal
    from sales s
    where s.productid = s.quantity;

-- no unidentified salespersons
select count(*)
    from sales s
    where s.salespersonid not in (select e.employeeid from employees e);

-- no unidentified customers
select count(*)
    from sales s
    where s.customerid not in (select c.customerid from customers c);

-- no unidentified products
select count(*)
    from sales s
    where s.productid not in (select p.productid from products p);

-- salesdate range looks fine - [2018-02-23 08:04:51.000,	2020-02-23 19:37:14.000]
select min(salesdate), max(salesdate)
    from sales;

-- No issues in loading data into a timestamp field, so all dates are valid.

-- sale quantity range looks fine - [1,500,1042]
select min(quantity), median(quantity), max(quantity)
    from sales;

-- ###############################
-- '''Employees Table Analysis'''
-- ###############################

-- no duplicate employeeids
select employeeid, count(*) from employees
    group by employeeid
    having count(*) > 1;

-- no records with distinct IDs but same attributes
select count(*), lower(firstname), lower(middleinitial), lower(lastname), lower(region)
    from employees
    group by lower(firstname), lower(middleinitial), lower(lastname), lower(region)
    having count(*) > 1;

-- no two employees with the same name
select count(*)
    from employees
    group by lower(firstname), lower(middleinitial), lower(lastname)
    having count(*) > 1;

-- one employee has more than one words in the last name. This is legally allowed.
select * from employees
    where firstname like '% %'
    or middleinitial like '% %'
    or lastname like '% %';

-- one employee has ' as the middle initial
select * from employees where employeeid=15;

-- One region is in two different cases: East and east.
select region, count(*) from employees
    group by region;

-- ###############################
-- '''Customers Table Analysis'''
-- ###############################


-- one duplicate customerid
select customerid, count(*) from customers
    group by customerid
    having count(*) > 1;

-- two records for Stephanie Smith
select lower(firstname), lower(middleinitial), lower(lastname), count(*)
    from customers
    group by lower(firstname), lower(middleinitial), lower(lastname)
    having count(*) > 1;

-- all duplicate records - only Stephanie Smith in this case.
select * from customers
    where customerid in
    (select customerid from customers
        group by customerid
        having count(*) > 1);

-- few customers have more than one words in the first name, or last name. This is legally allowed.
select * from customers
    where firstname like '% %'
    or middleinitial like '% %'
    or lastname like '% %';


-- ###############################
-- '''Products Table Analysis'''
-- ###############################

-- no duplicate productids
select productid, count(*) from products
    group by productid
    having count(*) > 1;

-- no duplicate names
select lower(name), count(*) from products
    group by lower(name)
    having count(*) > 1;

-- Prices are in acceptable range ~ [0, 269, 3578]
select min(price), median(price), max(price) from products;

-- Price of 48 products is 0. They're free?
select count(*) from products where price=0;


-- ###############################
-- '''Miscellaneous Analysis'''
-- ###############################

-- no employees are also customers
select * from customers c
    where exists
    (select * from employees e
     where lower(e.firstname) = lower(c.firstname)
     and lower(e.middleinitial) = lower(c.middleinitial)
     and lower(e.lastname) = lower(c.lastname));
