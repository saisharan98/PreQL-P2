-- environment set-up
use role sysadmin;
use warehouse compute_wh;

-- use the sales  database, and raw schema
use database preql_sales;
use schema raw;

--creating file formats

create or replace file format csv_comma type='csv'
  compression = 'auto' field_delimiter = ',' record_delimiter = '\n'
  skip_header = 1 field_optionally_enclosed_by = '\042' trim_space = false
  error_on_column_count_mismatch = false escape = 'none' escape_unenclosed_field = '\134'
  date_format = 'auto' timestamp_format = 'auto' null_if = ('') comment = 'CSV format with comma-separation';
  
create or replace file format csv_line type='csv'
  compression = 'auto' field_delimiter = '|' record_delimiter = '\n'
  skip_header = 1 field_optionally_enclosed_by = '\042' trim_space = false
  error_on_column_count_mismatch = false escape = 'none' escape_unenclosed_field = '\134'
  date_format = 'auto' timestamp_format = 'auto' null_if = ('') comment = 'CSV format with line-separation';
  

--verify file formats are created

show file formats in database preql_sales;
