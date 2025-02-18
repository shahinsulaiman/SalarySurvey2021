CREATE DATABASE SalarySurvey2021;
USE SalarySurvey2021;

CREATE TABLE SalarySurvey2021 (
    AgeRange VARCHAR(50),
    Industry VARCHAR(255),
    JobTitle VARCHAR(255),
    AnnualSalary INT,
    AdditionalMonetaryCompensation INT,
    Currency VARCHAR(10),
    Country VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100),
    YearsOfProfessionalExperienceOverall VARCHAR(50),
    YearsOfProfessionalExperienceInField VARCHAR(50),
    HighestLevelOfEducationCompleted VARCHAR(100),
    Gender VARCHAR(50)
);

-- a. Average Salary by Industry and Gender 
SELECT 
    Industry, 
    Gender, 
    AVG(AnnualSalary) AS Average_Salary
FROM salarysurvey2021.salarysurvey2021
GROUP BY Industry, Gender
ORDER BY Industry, Average_Salary DESC;

-- b. Total Salary Compensation by Job Title 
SELECT 
    JobTitle, 
    SUM(AnnualSalary + AdditionalMonetaryCompensation) AS Total_Compensation
FROM salarysurvey2021.salarysurvey2021
GROUP BY JobTitle
ORDER BY Total_Compensation DESC;

-- c. Salary Distribution by Education Level 
SELECT 
    HighestLevelofEducationCompleted AS Education_Level, 
    AVG(AnnualSalary) AS Average_Salary,
    MIN(AnnualSalary) AS Minimum_Salary,
    MAX(AnnualSalary) AS Maximum_Salary
FROM salarysurvey2021.salarysurvey2021
GROUP BY HighestLevelofEducationCompleted
ORDER BY Average_Salary DESC;

-- d. Number of Employees by Industry and Years of Experience 
SELECT 
    Industry, 
    YearsofProfessionalExperienceOverall AS Experience_Level, 
    COUNT(*) AS Employee_Count
FROM salarysurvey2021.salarysurvey2021
GROUP BY Industry, YearsofProfessionalExperienceOverall
ORDER BY Industry, Experience_Level;

-- e. Median Salary by Age Range and Gender
WITH RankedSalaries AS (
    SELECT
        AgeRange,
        Gender,
        AnnualSalary,
        ROW_NUMBER() OVER (PARTITION BY AgeRange, Gender ORDER BY AnnualSalary) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY AgeRange, Gender ORDER BY AnnualSalary DESC) AS RowDesc
    FROM SalarySurvey2021
),
MedianSalaries AS (
    SELECT
        AgeRange,
        Gender,
        AVG(AnnualSalary) AS MedianSalary
    FROM RankedSalaries
    WHERE RowAsc = RowDesc 
       OR RowAsc + 1 = RowDesc 
       OR RowAsc = RowDesc + 1
    GROUP BY AgeRange, Gender
)
SELECT
    AgeRange,
    Gender,
    ROUND(MedianSalary, 2) AS MedianSalary
FROM MedianSalaries
ORDER BY AgeRange, Gender;

-- f. Job Titles with the Highest Salary in Each Country
WITH RankedJobs AS (
    SELECT 
        Country, 
        JobTitle, 
        AnnualSalary, 
        RANK() OVER (PARTITION BY Country ORDER BY AnnualSalary DESC) AS rnk
    FROM salarysurvey2021.salarysurvey2021
)
SELECT Country, JobTitle, AnnualSalary
FROM RankedJobs
WHERE rnk = 1
ORDER BY Country;

-- g. Average Salary by City and Industry
SELECT 
    City, 
    Industry, 
    AVG(AnnualSalary) AS Average_Salary
FROM salarysurvey2021.salarysurvey2021
GROUP BY City, Industry
ORDER BY City, Industry;

-- h. Percentage of Employees with Additional Monetary Compensation by Gender
SELECT 
    Gender, 
    COUNT(CASE WHEN AdditionalMonetaryCompensation > 0 THEN 1 END) * 100.0 / COUNT(*) AS Percentage_With_Compensation
FROM salarysurvey2021
GROUP BY Gender
ORDER BY Percentage_With_Compensation DESC;

-- i. Total Compensation by Job Title and Years of Experience 
SELECT 
    JobTitle, 
    YearsofProfessionalExperienceOverall AS Experience_Level, 
    SUM(AnnualSalary + AdditionalMonetaryCompensation) AS Total_Compensation
FROM salarysurvey2021.salarysurvey2021
GROUP BY JobTitle, YearsofProfessionalExperienceOverall
ORDER BY JobTitle, Experience_Level;

-- j. Average Salary by Industry, Gender, and Education Level 
SELECT 
    Industry, 
    Gender, 
    HighestLevelofEducationCompleted AS Education_Level, 
    AVG(AnnualSalary) AS Average_Salary
FROM salarysurvey2021.salarysurvey2021
GROUP BY Industry, Gender, HighestLevelofEducationCompleted
ORDER BY Industry, Gender, Average_Salary DESC;

