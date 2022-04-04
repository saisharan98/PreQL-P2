-- environment set-up
use role sysadmin;
use warehouse compute_wh;

-- create database
create database preql_sales;

-- create 'raw' schema
create schema raw;

-- use the newly created database, and schema
use database preql_sales;
use schema raw;

-- create tables to store the data

create or replace table Sales
(OrderID integer,
 SalesPersonID integer,
 CustomerID integer,
 ProductID integer,
 Quantity integer,
SalesDate timestamp);

create or replace table Employees
(EmployeeID integer,
 FirstName string,
 MiddleInitial string,
 LastName string,
 Region string);

create or replace table Customers
(CustomerID integer,
 FirstName string,
 MiddleInitial string,
 LastName string);

create or replace table Products
(ProductID integer,
 Name string,
Price float);


-- create stages

create stage raw_customers
url = 's3://seng5709/customers/';

create stage raw_employees
url = 's3://seng5709/employees/';

create stage raw_products
url = 's3://seng5709/products/';

create stage raw_sales
url = 's3://seng5709/sales/';

-- check the files inside stage

list @raw_customers;
list @raw_employees;
list @raw_products;
list @raw_sales;
