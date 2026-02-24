CREATE DATABASE db_loan;

USE db_loan;

CREATE TABLE loan_raw (
    applicant_id INT,
    age INT,
    gender VARCHAR(20),
    marital_status VARCHAR(20),
    annual_income DECIMAL(10,2),
    loan_amount DECIMAL(10,2),
    credit_score INT,
    num_dependents INT,
    existing_loans_count INT,
    employment_status VARCHAR(50),
    loan_approved INT
);

-- EDA

SELECT * FROM loan_raw;

SELECT * FROM loan_raw WHERE annual_income IS NULL OR credit_score IS NULL;

SELECT
	applicant_id,
    COUNT(*) 
FROM
	loan_raw
GROUP BY applicant_id
HAVING COUNT(*) > 1;

SELECT *
FROM loan_raw
WHERE credit_score < 300 OR credit_score > 900;

-- feature engineering

CREATE TABLE loan_analysis AS
SELECT
	*,
    (loan_amount / annual_income) AS dti_ratio,
    CASE
    WHEN credit_score > 750 THEN 'Low Risk'
    WHEN credit_score BETWEEN 650 AND 749 THEN 'Medium Risk'
    ELSE 'High Risk'
    END AS risk_category,
    CASE 
        WHEN annual_income < 50000 THEN 'Low Income'
        WHEN annual_income BETWEEN 50000 AND 100000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group
FROM
	loan_raw;
    
-- EDA
    
SELECT * FROM loan_analysis;

SELECT
	COUNT(*)
FROM
	loan_analysis;
    
SELECT 
    COUNT(*) AS total,
    SUM(loan_approved) AS approved,
    ROUND(SUM(loan_approved)/COUNT(*) * 100.0,2) AS approval_rate
FROM loan_analysis;

SELECT
	credit_score,
    COUNT(*)
FROM
	loan_analysis
GROUP BY credit_score
ORDER BY credit_score DESC;

SELECT
	income_group,
    COUNT(*) AS no_of_applicants
FROM
	loan_analysis
GROUP BY income_group
ORDER BY no_of_applicants DESC;

SELECT
	risk_category,
    COUNT(*) AS no_of_applicants
FROM
	loan_analysis
GROUP BY risk_category
ORDER BY no_of_applicants DESC;

SELECT
	income_group,
    ROUND(SUM(loan_approved) / COUNT(*) * 100.0, 2) AS approval_rate
FROM
	loan_analysis
GROUP BY income_group
ORDER BY approval_rate DESC;

SELECT
	employment_status,
    ROUND(SUM(loan_approved) / COUNT(*) * 100.0, 2) AS approval_rate
FROM
	loan_analysis
GROUP BY employment_status
ORDER BY approval_rate DESC;

SELECT
	CASE
	WHEN loan_approved = 1 THEN "Yes"
    ELSE "No" END AS loan_approved,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM
	loan_analysis
GROUP BY loan_approved
ORDER BY avg_loan_amount DESC;

SELECT
	risk_category,
    ROUND(SUM(loan_approved) * 100.0 / COUNT(*), 2) AS approval_rate
FROM
	loan_analysis
GROUP BY risk_category
ORDER BY approval_rate DESC;