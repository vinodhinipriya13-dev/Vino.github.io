SELECT * FROM portfolio..telco_customer_churn;

--Overall Churn Rate
SELECT
    COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'YES' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(
         SUM(CASE WHEN churn = 'YES' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churned_rate_percent
FROM portfolio..telco_customer_churn;

--Churn by Internet Service
SELECT 
    InternetService,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
        ROUND(
            SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM portfolio..telco_customer_churn
GROUP BY InternetService;

--Churn by Gender
SELECT 
    gender,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
        ROUND(
            SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM portfolio..telco_customer_churn
GROUP BY gender;

--Contract Type vs Churn
SELECT 
    Contract,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM portfolio..telco_customer_churn
GROUP BY Contract;

--High-Value Customers at Risk
SELECT customerID,tenure,MonthlyCharges,Contract
    FROM portfolio..telco_customer_churn
WHERE churn = 'Yes'
  AND MonthlyCharges > (
      SELECT AVG(MonthlyCharges) FROM portfolio..telco_customer_churn)
ORDER BY MonthlyCharges DESC;


--Tenure vs Churn
WITH tenure_bucket AS (
    SELECT *,
        CASE 
            WHEN tenure < 12 THEN '0-1 YEAR'
            WHEN tenure BETWEEN 12 AND 24 THEN '1-2 YEAR'
            ELSE '2+ YEAR'
        END AS tenure_group
    FROM portfolio..telco_customer_churn
)
SELECT 
    tenure_group,
        ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
   FROM tenure_bucket
    GROUP BY tenure_group
    ORDER BY churn_rate DESC;

--Average Revenue Per User (ARPU)
SELECT
    ROUND(AVG(monthlyCharges),2) AS Per_User_Charge
 FROM portfolio..telco_customer_churn;

 --Revenue Lost Due to Churn
 SELECT 
    ROUND(SUM(monthlyCharges),2) AS monthly_revenue_lost
 FROM portfolio..telco_customer_churn
    WHERE churn = 'YES';

--Retention Rate
--Retention = customers who stayed
SELECT
  ROUND(SUM(CASE WHEN churn ='NO' THEN 1 ELSE 0 END)*100,2) AS retention_rate_percent
FROM portfolio..telco_customer_churn;

--Service Add-Ons vs Churn
SELECT OnlineSecurity,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM portfolio..telco_customer_churn
    GROUP BY OnlineSecurity;

--Top Churn Risk Customers (Target List)
SELECT CustomerId,Tenure,MonthlyCharges,Contract
    FROM portfolio..telco_customer_churn
 WHERE churn ='YES'
    AND tenure < 12
    AND contract ='Month-to-month'
 ORDER BY MonthlyCharges DESC;
















