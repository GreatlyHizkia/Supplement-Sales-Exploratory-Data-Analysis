# Supplement Sales Exploratory Data Analysis - SQL Server

## Project Overview
For this project, I performed data cleaning, exploratory data analysis and uncovered trends using SQL Server.

**Key Business Questions Addressed:**
1. Which product supplements generate the most revenue and the least revenue? 
2. Which supplement categories are purchased most often and least often?
3. Which locations sell the most products and generate the most revenue each year?
4. Which products are returned most often by customers?
5. What are the trends in total revenue and sales volume over time (annually)?
6. What Platform the customers use the most in every Location?

## Source Data
This data was downloaded from kaggle: https://www.kaggle.com/datasets/zahidmughal2343/supplement-sales-data

## 🔄 Workflow Process
1. **Data Loading:** Import the data from csv file to SQL server  
2. **Data Cleaning & Preprocessing:** Change format date column from this format '2020-01-06 00:00:00.0000000' to this format '2020-01-06', Add new column 'Price_before_discount' with formula 'Price = Price / (1 - Discount), Change data type column 'Units_Returned' From Nvarchar to Int, Add Column 'Revenue_before_disc' 
3. **Exploratory Data Analysis (EDA)** using queries like `CTE, Aggregation, Subqueries, Window Function and Set Operator Union All`

## 🔍 Key Insights & Findings
1. Product supplements generate the `most revenue` are 'Biotin, Zinc, Pre-Workout, BCAA, Fish Oil' and Product supplements generate the `least revenue` are 'Magnesium, Multivitamin, Melatonin, Ashwagandha, Electrolyte Powder'
2. Supplement categories are purchased `most often` are 'Mineral, Vitamin, Performance' and Supplement categories are purchased `least often` are 'Fat Burner, Amino Acid, Hydartion'
3. Locations that sell the most products and generate the most revenue is (UK in 2020,2021 and 2023, Canada in 2022,2024 and 2025)
4. Products which were returned the most by customers are 'Vitamin C, Electrolyte Powder, and Magnesium'
5. In Canada customers tend to use platform 'Amazon', in UK customers tend to use 'iHerb', and in USA they use 'Amazon'.

## Business Recommendations
1. **Quality & Description Audit:** Immediately launch a quality control and product description audit for these three products across all platforms. High returns often indicate a mismatch between customer expectation and product reality (quality issue, misleading packaging, or inaccurate online description).
2. **Strategic Bundling:** Utilize top-performing products (Biotin, Zinc, Pre-Workout) to boost sales of low-revenue items. Implement bundles, such as pairing Electrolyte Powder with Pre-Workout, to introduce customers to less popular items.
3. **Formula Review or Discontinuation:** Conduct a swift cost-benefit analysis. If the quality/return issues for these two critical products cannot be immediately resolved, consider revising the product formula or phasing them out to protect brand reputation and profitability.
4. **Market Dominance Campaign:** Allocate the majority (60-70%) of the marketing budget to maintain and expand market share within these three high-demand categories. Ensure high stock levels for products like Zinc, Biotin, and Pre-Workout.
5. **Capitalize on Momentum:** Increase inventory and logistical focus in the Canadian market to fully capitalize on this recent surge in growth. Simultaneously, investigate the reason for the UK's market share decline to identify opportunities for recovery (e.g., competitive pricing, shipping issues).

## Project Structure & Code
All SQL scripts are organized below, showcasing the analytical progression:

| File | Description |
| :--- | :--- |
| `Supplement_Sales_Weekly_Expanded.csv` | Original raw dataset from Kaggle. |
| `Supplement Sales Project.sql` |

## View the Full Analysis
Full project code and detailed SQL scripts are available in the repository folders. I'm open to connect and discuss this project! 👇

##  About Me

Hi, I’m **Greatly Hizkia Manua**  

An **aspiring Data Analyst** and **aspiring Data Scientist** with a passion for uncovering stories hidden in data. My journey is all about exploring how data shapes strategy, and each project helps me grow closer to that goal.

Feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/greatlyhizkiamanua/) or explore more of my work on [GitHub](https://github.com/GreatlyHizkia).
