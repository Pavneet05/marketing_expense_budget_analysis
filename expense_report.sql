/* =========================================================
   PROJECT: Marketing Expense & Campaign Budget Analysis
   FILE: expense_reports.sql

   PURPOSE:
   This file contains SQL queries used to generate leadership
   reports for analyzing marketing program expenses, campaign
   budgets, and high-cost activities.
   ========================================================= */


/* =========================================================
   REPORT 1: PROGRAM EXPENSE REPORT
   ---------------------------------------------------------
   This report lists:
   - Program name
   - Program start and end dates
   - Campaign name
   - Activity name
   - Total expenses

   BUSINESS VALUE:
   Helps leadership understand how marketing spend is
   distributed across programs, campaigns, and activities.
   ========================================================= */

SELECT 
    P.Program_Name,
    P.Start_Date,
    P.End_Date,
    C.Campaign_Name,
    A.Activity_Name,
    ROUND(SUM(E.Expense_Amount), 0) AS Total_Expenses
FROM Program P
JOIN Campaign C 
    ON P.Program_Id = C.Program_Id
JOIN Activity A  
    ON C.Campaign_Id = A.Campaign_Id
JOIN Expenses E
    ON A.Activity_Id = E.Activity_Id
GROUP BY 
    P.Program_Name,
    P.Start_Date,
    P.End_Date,
    C.Campaign_Name,
    A.Activity_Name
ORDER BY 
    P.Program_Name,
    C.Campaign_Name,
    A.Activity_Name;


/* =========================================================
   REPORT 2: PROGRAM MONTHLY AVERAGE EXPENSES
   ---------------------------------------------------------
   This report calculates:
   - Monthly total expenses per program
   - Monthly average expenses using a window function

   BUSINESS VALUE:
   Helps leadership identify spending trends and seasonality
   in marketing programs.
   ========================================================= */

SELECT 
    P.Program_Name,
    YEAR(E.Expense_Date) AS Expense_Year,
    MONTH(E.Expense_Date) AS Expense_Month,
    SUM(E.Expense_Amount) AS Total_Expense,
    ROUND(
        AVG(SUM(E.Expense_Amount)) 
        OVER (PARTITION BY P.Program_Name), 
    2) AS Monthly_Average_Expense
FROM Program P
JOIN Campaign C 
    ON P.Program_Id = C.Program_Id
JOIN Activity A  
    ON C.Campaign_Id = A.Campaign_Id
JOIN Expenses E
    ON A.Activity_Id = E.Activity_Id
GROUP BY 
    P.Program_Name,
    YEAR(E.Expense_Date),
    MONTH(E.Expense_Date)
ORDER BY 
    P.Program_Name,
    Expense_Year,
    Expense_Month;


/* =========================================================
   REPORT 3: CAMPAIGN BUDGET UTILIZATION REPORT
   ---------------------------------------------------------
   This report compares:
   - Total campaign expenses
   - Campaign budget
   - Budget utilization percentage

   BUSINESS VALUE:
   Allows leadership to monitor how efficiently each campaign
   is using its allocated budget.
   ========================================================= */

SELECT 
    P.Program_Name,
    C.Campaign_Name,
    SUM(E.Expense_Amount) AS Total_Expenses,
    C.Budget_Amount AS Campaign_Budget,
    ROUND(
        (SUM(E.Expense_Amount) / C.Budget_Amount) * 100, 
    2) AS Budget_Utilization_Percent
FROM Program P
JOIN Campaign C 
    ON P.Program_Id = C.Program_Id
JOIN Activity A  
    ON C.Campaign_Id = A.Campaign_Id
JOIN Expenses E
    ON A.Activity_Id = E.Activity_Id
GROUP BY 
    P.Program_Name,
    C.Campaign_Name,
    C.Budget_Amount
ORDER BY 
    Budget_Utilization_Percent DESC;


/* =========================================================
   REPORT 4: CAMPAIGN BUDGET STATUS REPORT
   ---------------------------------------------------------
   This report categorizes campaigns as:
   - Over Budget
   - Exactly On Budget
   - Within Budget

   BUSINESS VALUE:
   Provides a quick dashboard-style view for managers to
   identify campaigns that require cost control.
   ========================================================= */

SELECT 
    C.Campaign_Name,
    C.Budget_Amount,
    SUM(E.Expense_Amount) AS Total_Expenses,
    CASE
        WHEN SUM(E.Expense_Amount) > C.Budget_Amount 
            THEN 'Over Budget'
        WHEN SUM(E.Expense_Amount) = C.Budget_Amount 
            THEN 'Exactly On Budget'
        ELSE 'Within Budget'
    END AS Budget_Status
FROM Campaign C
JOIN Activity A  
    ON C.Campaign_Id = A.Campaign_Id
JOIN Expenses E
    ON A.Activity_Id = E.Activity_Id
GROUP BY 
    C.Campaign_Name,
    C.Budget_Amount
ORDER BY 
    Budget_Status;


/* =========================================================
   REPORT 5: HIGH-COST ACTIVITIES USING RANK()
   ---------------------------------------------------------
   This report identifies:
   - Highest-cost activities within each campaign

   TECHNIQUE USED:
   - Common Table Expression (CTE)
   - RANK() window function

   BUSINESS VALUE:
   Helps the marketing team identify cost-heavy activities
   and improve future budgeting decisions.
   ========================================================= */

WITH Activity_Costs AS (
    SELECT 
        C.Campaign_Name,
        A.Activity_Name,
        SUM(E.Expense_Amount) AS Total_Activity_Expense
    FROM Campaign C
    JOIN Activity A 
        ON C.Campaign_Id = A.Campaign_Id
    JOIN Expenses E 
        ON A.Activity_Id = E.Activity_Id
    GROUP BY 
        C.Campaign_Name,
        A.Activity_Name
)
SELECT 
    Campaign_Name,
    Activity_Name,
    Total_Activity_Expense,
    RANK() OVER (
        PARTITION BY Campaign_Name 
        ORDER BY Total_Activity_Expense DESC
    ) AS Expense_Rank
FROM Activity_Costs;
