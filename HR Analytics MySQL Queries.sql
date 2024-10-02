CREATE DATABASE HR2;
USE HR2;
SELECT * FROM HR_1;

ALTER TABLE HR_1
ADD COLUMN AttritionCount INT;

UPDATE HR_1 
SET AttritionCount = CASE 
	WHEN Attrition = "Yes" THEN 1 ELSE 0
	END;

/*Attrition Rate*/
SELECT CONCAT(ROUND((SUM(AttritionCount)/SUM(EmployeeCount))*100,2),"%") AS "Attrition Rate" 
FROM HR_1;

/*1. Average Attrition rate for all Departments*/
SELECT Department, CONCAT(ROUND(AVG(AttritionCount)*100,2),"%") AS "Attrition Rate" 
FROM HR_1 
GROUP BY Department;

/*2. Average Hourly rate of Male Research Scientist*/
SELECT Gender, JobRole AS "Job Role", ROUND(AVG(HourlyRate),2) AS "Average Hourly Rate" 
FROM HR_1 
WHERE Gender="Male" AND JobRole="Research Scientist";


/*3. Attrition rate Vs Monthly income stats*/
SELECT 
    IncomeRange AS "Monthly Income",
    CONCAT(ROUND((SUM(AttritionCount) * 100.0 / SUM(EmployeeCount)), 2), '%') AS "Attrition Rate"
FROM (
    SELECT 
        (CASE
			WHEN MonthlyIncome > 50000 THEN '50K+'
            WHEN MonthlyIncome > 40000 THEN '40K-50K'
            WHEN MonthlyIncome > 30000 THEN '30K-40K'
            WHEN MonthlyIncome > 20000 THEN '20K-30K'
            WHEN MonthlyIncome > 10000 THEN '10K-20K'
            WHEN MonthlyIncome > 10000 THEN '1K-10K'
            ELSE '1K-10K'
	END) AS IncomeRange,
	HR_1.AttritionCount,
	HR_1.EmployeeCount
    FROM HR_1
    INNER JOIN HR_2 ON HR_1.EmployeeNumber = HR_2.EmployeeID
) AS Bins
GROUP BY IncomeRange;

/*4. Average working years for each Department*/
SELECT H1.Department, ROUND(AVG(H2.TotalWorkingYears),1) AS "Avg. Working Years"
FROM HR_1 H1
JOIN HR_2 H2 ON H1.EmployeeNumber=H2.EmployeeID
GROUP BY H1.Department;

/*5. Job Role Vs Work life balance*/
SELECT H1.JobRole AS "Job Role", 
MIN(CASE
	WHEN H2.WorkLifeBalance=4 THEN "Excellent"
    WHEN H2.WorkLifeBalance=3 THEN "Good"
    WHEN H2.WorkLifeBalance=2 THEN "Average"
    WHEN H2.WorkLifeBalance=1 THEN "Poor"
END) AS "Work-Life Balance"
FROM HR_1 H1
JOIN HR_2 H2 ON H1.EmployeeNumber=H2.EmployeeID
GROUP BY H1.JobRole;

/*6. Attrition rate Vs Year since last promotion relation*/
SELECT 
    YearRange AS "Years since Last Promotion",
    CONCAT(ROUND((SUM(AttritionCount) * 100.0 / SUM(EmployeeCount)), 2), '%') AS "Attrition Rate"
FROM (
    SELECT 
        (CASE
			WHEN YearsSinceLastPromotion > 30 THEN '30-40'
            WHEN YearsSinceLastPromotion > 20 THEN '20-30'
            WHEN YearsSinceLastPromotion > 10 THEN '10-20'
            WHEN YearsSinceLastPromotion > 0 THEN '1-10'
            ELSE '1-10'
	END) AS YearRange,
	HR_1.AttritionCount,
	HR_1.EmployeeCount
    FROM HR_1
    INNER JOIN HR_2 ON HR_1.EmployeeNumber = HR_2.EmployeeID
) AS Bins
GROUP BY YearRange;