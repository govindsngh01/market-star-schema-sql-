# market-star-schema-sql-
SQL Sales Analytics Project | MySQL 8.0 | Star Schema | Window Functions | CTEs

# SQL Sales Analytics - Star Schema Project
An end-to-end SQL analysis project on a Star Schema sales dataset using MySQL 8.0.
Focus: Window Functions, CTEs, Business KPIs, and Customer Segmentation.
### Tech Stack
- MySQL 8.0+
- Window Functions: LAG(), RANK(), SUM() OVER(), Row_number
- CTEs for readable analytics
- Star Schema: Fact + Dimension tables

### Key Insights Solved
1.  **Profitability**: Top 5 products by profit margin
2.  **Pareto 80/20**: Top customers driving 80% profit
3.  **Trend Analysis**: MoM & YoY sales growth using LAG()
4.  **Loss Detection**: Products & orders with negative profit
5.  **RFM Analysis**: Segmented customers into Champions, At-Risk, Lost

### How to Run
1.  Run `schema.sql` to create tables
2.  Load data into `market_fact_full`, `cust_dimen`, `prod_dimen`, `shipping_dimen`
3.  Run queries from `advanced_analysis.sql`

### Screenshots
![Pareto Analysis] = (    )
q3_mom_growth.png
