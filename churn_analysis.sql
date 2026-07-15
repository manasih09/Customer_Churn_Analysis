USE churn_analysis;
SELECT COUNT(*)
FROM customer_churn;
DESCRIBE customer_churn;
SELECT *
FROM customer_churn
WHERE TotalCharges IS NULL;
SELECT COUNT(*)
FROM customer_churn
WHERE tenure = 0;

-- data cleaning
-- Missing Values
SELECT
    SUM(customerID IS NULL) AS missing_customerID,
	SUM(gender IS NULL) AS missing_gender,
    SUM(tenure IS NULL) AS missing_tenure,
    SUM(MonthlyCharges IS NULL) AS missing_monthly,
    SUM(TotalCharges IS NULL) AS missing_totalcharges,
    SUM(Churn IS NULL) AS missing_churn
FROM customer_churn;

-- Duplicate Customers
SELECT customerID,COUNT(*)
FROM customer_churn
GROUP BY customerID
HAVING COUNT(*)>1;

-- Validate Churn Values
SELECT DISTINCT Churn 
FROM customer_churn;

-- Validate Contract Values
SELECT DISTINCT Contract
FROM customer_churn;

-- Check for Blank Strings
SELECT COUNT(*)
FROM customer_churn
WHERE TRIM(customerID) = '';

SELECT COUNT(*)
FROM customer_churn
WHERE TRIM(TotalCharges) = '';

-- Outlier Check (Numeric Validation)
SELECT
    MIN(tenure),
    MAX(tenure),
    MIN(MonthlyCharges),
    MAX(MonthlyCharges),
    MIN(TotalCharges),
    MAX(TotalCharges)
FROM customer_churn;

-- Business Analysis
-- What is the overall churn rate in our telecom company?
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn;

-- Which contract type has the highest churn?
SELECT Contract,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Count_churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_percentage_per_contract
FROM customer_churn 
GROUP BY  Contract
 ;  
 
--  Are expensive plans causing customers to leave?
SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customer_churn
GROUP BY Churn;

-- Do new customers churn more than loyal customers?
-- Are customers leaving early after joining?

SELECT Churn,
       ROUND(AVG(tenure),2)  As avg_tenure
FROM  customer_churn
GROUP BY Churn;      

-- Does payment method influence churn?
SELECT PaymentMethod,
       ROUND(
             SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END )*100.0/ COUNT(*),
             2
             ) AS churn_rate
FROM customer_churn 
GROUP BY  PaymentMethod
ORDER BY churn_rate DESC;         

-- Which internet service has the highest churn?
SELECT InternetService,
       ROUND(SUM(CASE WHEN Churn= 'Yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*) ,2) AS churn_rate
FROM customer_churn     
GROUP BY InternetService
ORDER BY churn_rate DESC;  

-- Which combination is most dangerous?
-- Find churn rate by Contract + InternetService
SELECT Contract,InternetService,
       ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) ,2) AS churn_rate       
FROM customer_churn     
GROUP BY Contract,InternetService
ORDER BY churn_rate DESC
Limit 5;  




