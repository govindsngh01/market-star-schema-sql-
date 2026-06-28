## Market-star-schema-sql-
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
[Pareto Analysis] = ( https://github.com/govindsngh01/market-star-schema-sql-/blob/main/Pareto_analysis.png

[Mom growth analysis] = https://github.com/govindsngh01/market-star-schema-sql-/blob/main/Mom_growth_Sales.png

## 4. Key Insights & Conclusion
This analysis of the Market Star Schema reveals 3 key business insights:

1. **Pareto Analysis [80/20 Rule]:** Only top X customers contribute to 80% of the total company profit. 
    For example, `EMILY PHAN` and `GRANT CARROLL` alone generated ₹49,541 in profit. 
    This means business should prioritize VIP retention programs for this small group.
2. **Month-over-Month Growth Trend:** Sales dropped by 11.37% in Sep-02 vs Aug-01, but recovered strongly with a 22.15% growth in Sep-03. This indicates high volatility/seasonality and needs deeper investigation.
3. **Product Performance [Ranking]:** Top product categories account for majority of profit. Discounting strategy can be optimized for low-margin categories.
   
**Overall:** The dataset highlights that targeted marketing for high-value customers and optimizing discounts are the biggest levers for revenue growth.
