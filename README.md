# CSCI 5751 Project 2 - Snowflake Proof of Concept

CSCI 5751 Big Data Engineering & Architecture, Spring 2022\
Chad Dvoracek\
University of Minnesota

Team PreQL\
slack channel: spring22dataeng\
Avinash Akella\
Abhiraj Mohan\
Sai Sharan Sundar\
Josh Spitzer-Resnick

## Quality analysis of raw data
We ran a rigorous exploratory data analysis process to analyse the quality of our data.
We executed multiple sanity checks on our raw data tables to be able to 
filter those out in the curated data tables. In this section, we describe the EDA process.
All of these queries can be found in the `exploration_analysis.sql` file. 

#### Checking for duplicate IDs
We run a select query to check if there are any records in any of the four tables
`Sales`, `Employees`, `Customers`, `Products` that have duplicate IDs.
#### Checking for duplicate rows
This is to check if there are duplicate rows that might have different IDs but
are similar in every other attribute.
#### Checking for datetime formatting
The `Sales` table contains the date of the transaction and is formatted as timestamp.
We do a sanity check on this attribute to ensure that there were not any formatting discrepancies.
#### Checking for lower/upper case consistency
In all of these tables, there are mutliple attributes of type string. For these attributes,
we check to ensure that there are no inconsistencies in the case of these strings.
#### Table-specific checks
Apart from the general tests that we run for each table, we run table-specific tests
**Sales**: We found that roughly 50% of the records have the same quantity as the productID.
We also did a check on the `salesdate` to check if the range of dates made sense and found no issues.
**Employees**: We found that there are no two employees with the same name.
**Customers**: We found a few customers that have hyphenated first name, middle name and last name.
We also check if any of the customers are also employees and find it to be false.
**Products**: We found that about 48 products have 0 as their price.


## `curated` database description

cols, # records

## How to run
Please run the scripts in the order written below

| Run Order | Name of File | Path in Repo | Description |
| --- | --- | --- | --- |
| 1 | create_tables_and_stage.sql | /PreQL-P2 | Creates database, tables, schema and stages. |
| 2 | create_file_formats.sql | /PreQL-P2 | Creates formats for data |
| 3 | load_data.sql | /PreQL-P2 | Loads data into created tables from stages. |
| 4 | create_curated_tables.sql | /PreQL-P2 | Creates new schema using a clusterkey on 'customerid' of the 'sales' table and loads data into new tables. |
| 5 | create_views.sql | /PreQL-P2 | Creates two custom views: Aggregate total amount of all products purchased by month for 2019 and Top ten customers sorted by total dollar amount in sales from highest to lowest |
| 6 | drop_script.sql | /PreQL-P2 | Removes all tables, databases and schema in a cascade. |

## Materialized views and clustering use cases

[Materialized views](https://docs.snowflake.com/en/user-guide/views-materialized.html) store data from a query, which can then be queried without recomputing the original query. This is a useful optimization if a) the original query is complex or time or resource intensive, and/or b) the original query is very commonly repeated. [Clustering](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions.html) stores similar data together in local parititions. This is done automatically, but clustering keys can be defined to manually store specific data in similar locations.

Two use cases that could apply to this example include:
- Sorting or filtering a large daataset is a time and resource intensive task. If one was interested in querying only the top products being sold, top products an employee is selling, or top products a customer is buying, a materialized view could be created with the sorted information from most common to least common, which one could then query more often (e.g. for each product, employee, or customer) rather than recreating a sorted view each time a similar query was run. The materialized view could be recalculated depending on the granuality of data required (e.g. weekly or daily), as small continouus variations likely will not dramatically change trends amongst the most popular products.
- If one needed to sort sales by price or quantity but also to analyse top products or other metrics by region, a clustering key could be created on region so that queries looking for the top products in a region would only have to access a minimal number of dataset partitions, lowering the time required to compute them.
