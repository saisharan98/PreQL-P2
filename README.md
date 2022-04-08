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

## Raw data description
We provide a thorough description of the data through a data dictionary in this section.

**Sales**: This table contains records of each transaction. It can also be considered as the fact table in a star schema.

| Attribute | Data-type | Description |
| - | - | - |
| OrderID       | Integer (PK) | Unique identification for sales                                    |
| SalesPersonID | Integer (FK) | Unique identification for the salesperson responsible for the sale |
| CustomerID    | Integer (FK) | Unique identification for the customer for the sale                |
| ProductID     | Integer (FK) | Unique identification for the product sold                         |
| Quantity      | Integer      | Quantity of the product sold                                       |
| SalesDate     | Timestamp    | Date for the sale                                                  |

The other three tables act as dimension tables. The fact table `Sales` has foreign key references to each of these tables.

**Employees**: This table contains information about each employee

| Attribute | Data-type | Description |
| - | - | - |
| EmployeeID    | Integer (PK) | Unique identification for the employee                                       |
| FirstName     | String       | String representation for the first name of the employee                     |
| MiddleInitial | String       | String representation for the middle initial of the employee                 |
| LastName      | String       | String representation for the last name of the employee                      |
| Region        | String       | An abbreviated string representation for the region the employee operates in |

**Customers**: This table contains information about each customer

| Attribute | Data-type | Description |
| - | - | - |
| CustomerID    | Integer (PK) | Unique identification for the customer                       |
| FirstName     | String       | String representation for the first name of the employee     |
| MiddleInitial | String       | String representation for the middle initial of the employee |
| LastName      | String       | String representation for the last name of the employee      |

**Products**: This table contains information about each product

| Attribute | Data-type | Description |
| - | - | - |
| ProductID | Integer (PK) | Unique identification for the product             |
| Name      | String       | String representation for the name of the product |
| Price     | Float        | Price of the product                              |

## Quality analysis of raw data
We ran a rigorous exploratory data analysis process to analyse the quality of our data. We executed multiple sanity checks on our raw data tables to be able to filter those out in the curated data tables. In this section, we describe the EDA process. All of these queries can be found in the `exploration_analysis.sql` file. 

#### Checking for duplicate IDs
We run a select query to check if there are any records in any of the four tables `Sales`, `Employees`, `Customers`, `Products` that have duplicate IDs. None were found.

#### Checking for duplicate rows
This is to check if there are duplicate rows that might have different IDs but are similar in every other attribute. We did find one row in the Customers table, belonging to a 'Stephanie Smith', which was an exact replica of itself.

#### Checking for datetime formatting
The `Sales` table contains the date of the transaction and is formatted as timestamp. We do a sanity check on this attribute to ensure that there were not any formatting discrepancies.

#### Checking for lower/upper case consistency
In all of these tables, there are mutliple attributes of type string. For these attributes, we check to ensure that there are no inconsistencies in the case of these strings. As part of this, we found that the `region` field in the `employees` table has one region in two different cases: East and east, which we've corrected.

#### Table-specific checks
Apart from the general tests that we run for each table, we run table-specific tests:

**Sales**: We found that roughly 50% of the records have the same quantity as the productID. We also did a check on the `salesdate` to check if the range of dates made sense and found no issues.

**Employees**: We found that there are no two employees with the same name.

**Customers**: We found a few customers that have hyphenated first name, middle name and last name. We also check if any of the customers are also employees and find it to be false.

**Products**: We found that about 48 products have 0 as their price.

## `curated` database description

We cleaned the data by removing a duplicate record in the `Customers` table, and converting the `region` field in `Employees` to lower case to account for inconsistencies. We noticed that our queries for two of the views heavily rely on grouping by the `customerid` field of the `Sales` table, so we decided to create a cluster key on that field. The idea is that clustering similar records beforehand will reduce query runtime, especially for big data.

| Table | Number of records |
| - | - |
| Sales     | 6.7M |
| Employees | 19.8K |
| Customers | 23 |
| Products  | 504 |

## How to run
Please run the scripts in the order written below

| Run Order | Name of File                | Path in Repo                          | Description                                                                                                                                                                                                                                                                                                      |
|-----------|-----------------------------|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1         | create_tables_and_stage.sql | /PreQL-P2/create_tables_and_stage.sql | Creates database, tables, 'raw' schema and stages.                                                                                                                                                                                                                                                               |
| 2         | create_file_formats.sql     | /PreQL-P2/create_file_formats.sql     | Creates file formats for data.                                                                                                                                                                                                                                                                                   |
| 3         | load_data.sql               | /PreQL-P2/load_data.sql               | Loads data into created tables from stages.                                                                                                                                                                                                                                                                      |
| 4         | exploration_analysis.sql    | /PreQL-P2/exploration_analysis.sql    | Conducts exploratory analysis on the raw data tables.                                                                                                                                                                                                                                                            |
| 5         | create_curated_tables.sql   | /PreQL-P2/create_curated_tables.sql   | Clones 'raw' schema as 'curated'. Creates a clusterkey on 'customerid' field of the 'sales' table, and loads data into 'curated' schema tables after cleaning it.                                                                                                                                                |
| 6         | create_views.sql            | /PreQL-P2/create_views.sql            | Creates three custom views: **customer_monthly_sales_2019_view:** Aggregate total amount of all products purchased by month for 2019, **customer_monthly_sales_2019_view:** Top ten customers sorted by total dollar amount in sales from highest to lowest, and **product_sales_view:** product and sales view. |
| 7         | drop_script.sql             | /PreQL-P2/drop_script.sql             | Removes all tables, databases, schemas etc in a cascade.                                                                                                                                                                                                                                                         |

For testing, we used the following commands:

1: `set SNOWSQL_PRIVATE_KEY_PASSPHRASE=snowflakeproject`


2: `snowsql -a xt67644.ca-central-1.aws -u Avinash`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f create_tables_and_stage.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f create_file_formats.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f load_data.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f exploration_analysis.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f create_curated_tables.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f create_views.sql`

`snowsql -a xt67644.ca-central-1.aws -u Avinash -f drop_script.sql`

## Materialized views and clustering use cases

[Materialized views](https://docs.snowflake.com/en/user-guide/views-materialized.html) store data from a query, which can then be queried without recomputing the original query. This is a useful optimization if a) the original query is complex or time or resource intensive, and/or b) the original query is very commonly repeated. [Clustering](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions.html) stores similar data together in local parititions. This is done automatically, but clustering keys can be defined to manually store specific data in similar locations.

Two use cases that could apply to this example include:
- Sorting or filtering a large dataset is a time and resource intensive task. If one was interested in querying only the top products being sold, top products an employee is selling, or top products a customer is buying, a materialized view could be created with the sorted information from most common to least common, which one could then query more often (e.g. for each product, employee, or customer) rather than recreating a sorted view each time a similar query was run. The materialized view could be recalculated depending on the granuality of data required (e.g. weekly or daily), as small continouus variations likely will not dramatically change trends amongst the most popular products.
- If one needed to sort sales by price or quantity but also to analyse top products or other metrics by region, a clustering key could be created on region so that queries looking for the top products in a region would only have to access a minimal number of dataset partitions, lowering the time required to compute them.
