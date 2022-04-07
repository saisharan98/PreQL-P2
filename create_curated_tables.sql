-- environment set-up
use role sysadmin;
use warehouse compute_wh;

-- use the old schema
use database preql_sales;
use schema raw;

-- clone the raw schema
create schema curated clone raw;

-- switch to the newly created schema
use database preql_sales;
use schema curated;

-- delete old data from tables
delete from customers;
delete from employees;
delete from products;
delete from sales;

-- create cluster key on customerid of sales table
alter table sales cluster by (customerid);

-- populate tables with new data
insert into customers (select distinct * from preql_sales.raw.customers);
insert into employees (select distinct employeeid, firstname, middleinitial, lastname, lower(region) as region
                       from preql_sales.raw.employees);
insert into products (select distinct * from preql_sales.raw.products);
insert into sales (select distinct * from preql_sales.raw.sales);
