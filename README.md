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

## `curated` database description

cols, # records

## How to run
Please run the scripts in the order written below

| Run Order | Name of File | Path in Repo | Description |
| --- | --- | --- | --- |
| 1 | `code` | PreQL-P2 | |
| 2 | `code` | PreQL-P2 | |
| 3 | `code` | PreQL-P2 | |
| 4 | `code` | PreQL-P2 | |
| 5 | `code` | PreQL-P2 | |
| 6 | drop_script.sql | PreQL-P2 | Removes all tables, databases and schema in a cascade. |

## Materialized views and clustering use cases

[Materialized views](https://docs.snowflake.com/en/user-guide/views-materialized.html) store data from a query, which can then be queried without recomputing the original query. This is a useful optimization if a) the original query is complex or time or resource intensive, and/or b) the original query is very commonly repeated. [Clustering](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions.html) stores similar data together in local parititions. This is done automatically, but clustering keys can be defined to manually store specific data in similar locations.

Two use cases that could apply to this example include:
- Sorting or filtering a large daataset is a time and resource intensive task. If one was interested in querying only the top products being sold, top products an employee is selling, or top products a customer is buying, a materialized view could be created with the sorted information from most common to least common, which one could then query more often (e.g. for each product, employee, or customer) rather than recreating a sorted view each time a similar query was run. The materialized view could be recalculated depending on the granuality of data required (e.g. weekly or daily), as small continouus variations likely will not dramatically change trends amongst the most popular products.
- If one needed to sort sales by price or quantity but also to analyse top products or other metrics by region, a clustering key could be created on region so that queries looking for the top products in a region would only have to access a minimal number of dataset partitions, lowering the time required to compute them.
