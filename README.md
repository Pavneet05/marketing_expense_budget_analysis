# Marketing Expense & Campaign Budget Analysis (SQL)

## Project Overview
This project analyzes marketing programs, campaigns, activities, and expenses to support leadership-level financial decision-making.

The analysis focuses on tracking expenses, monitoring campaign budgets, identifying overspending, and improving budget efficiency.

## Database Design
The database includes the following tables:
- Program
- Campaign
- Activity
- Expenses
- Invoice

Relationships:
- One Program has many Campaigns
- One Campaign has many Activities
- One Activity has many Expenses and Invoices
- Expenses and Invoices have a one-to-one relationship

## Reports & Analysis Performed
- Program-level expense reports
- Monthly average expense analysis
- Campaign budget utilization and budget status
- Identification of over-budget and under-budget campaigns
- High-cost activity analysis using ranking functions

## SQL Techniques Used
- JOINs
- Aggregations (SUM, AVG)
- CASE statements
- CTEs
- Window functions (RANK)

## Business Outcomes
- Identified campaigns exceeding allocated budgets
- Highlighted high-cost activities for cost optimization
- Provided actionable insights for marketing leadership







