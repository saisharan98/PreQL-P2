-- environment set-up
use role sysadmin;
use warehouse compute_wh;


-- use the newly created database, and schema
use database preql_sales;
use schema raw;

-- load data into the created tables

copy into Customers from @raw_customers file_format=csv_line PATTERN = '.*csv.*' ;
copy into Employees from @raw_employees file_format=csv_comma PATTERN = '.*csv.*' ;
copy into Products from @raw_products file_format=csv_line PATTERN = '.*csv.*' ;
copy into Sales from @raw_sales file_format=csv_line PATTERN = '.*csv.*' ;
