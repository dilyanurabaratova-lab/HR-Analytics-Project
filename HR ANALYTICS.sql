SELECT * FROM employees

--Add an auto-incrementing ID column
ALTER TABLE employees
ADD EmployeeID INT IDENTITY(1,1);

--Verify it worked
SELECT TOP 10 EmployeeID, Age, Department, Attrition 
FROM employees
ORDER BY EmployeeID;

--make it the Primary Key

ALTER TABLE employees
ADD CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);


-- Q1: Overall attrition rate
SELECT 
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees;

-- Q2: Attrition rate by department
SELECT 
  Department,
  COUNT(*) AS headcount,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- Q3: Attrition rate by education field
SELECT 
  EducationField,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY EducationField
ORDER BY attrition_rate_pct DESC;

-- Q4: Attrition rate by marital status
SELECT 
  MaritalStatus,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;

-- Q5: Compensation gap: leavers vs stayers, by department
SELECT 
  Department,
  Attrition,
  CAST(AVG(CAST(MonthlyIncome AS FLOAT)) AS DECIMAL(10,0)) AS avg_income,
  COUNT(*) AS headcount
FROM employees
GROUP BY Department, Attrition
ORDER BY Department, Attrition;

-- Q6: Average tenure before leaving, by department
SELECT 
  Department,
  CAST(AVG(CAST(YearsAtCompany AS FLOAT)) AS DECIMAL(5,1)) AS avg_tenure_at_exit
FROM employees
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY avg_tenure_at_exit ASC;

-- Q7: Job satisfaction vs attrition
SELECT 
  JobSatisfaction,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Q8: Environment satisfaction vs attrition
SELECT 
  EnvironmentSatisfaction,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- Q9: Work-life balance vs attrition
SELECT 
  WorkLifeBalance,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Q10: Compounded risk segment (low satisfaction + low work-life balance + short tenure)
SELECT 
  CASE 
    WHEN JobSatisfaction <= 2 AND WorkLifeBalance <= 2 AND YearsAtCompany <= 3 
    THEN 'High Risk' 
    ELSE 'Other' 
  END AS risk_segment,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY 
  CASE 
    WHEN JobSatisfaction <= 2 AND WorkLifeBalance <= 2 AND YearsAtCompany <= 3 
    THEN 'High Risk' 
    ELSE 'Other' 
  END;

  --Q11: Distance from home vs attrition 

  SELECT 
  CASE 
    WHEN DistanceFromHome <= 5 THEN '0-5 km'
    WHEN DistanceFromHome <= 15 THEN '6-15 km'
    ELSE '16+ km'
  END AS distance_band,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY 
  CASE 
    WHEN DistanceFromHome <= 5 THEN '0-5 km'
    WHEN DistanceFromHome <= 15 THEN '6-15 km'
    ELSE '16+ km'
  END
ORDER BY distance_band;

--Q12: Number of companies worked vs attrition

SELECT 
  NumCompaniesWorked,
  COUNT(*) AS headcount,
  CAST(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS attrition_rate_pct
FROM employees
GROUP BY NumCompaniesWorked
ORDER BY NumCompaniesWorked;