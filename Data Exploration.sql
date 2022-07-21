-- A Data Exploration on Data science roles and their salaries from year 2020 to 2022

-- fetching data employees salaries
SELECT * FROM ds_salaries;

-- fetching data employees names
SELECT * FROM employee_names;

UPDATE employee_names
SET FirstName = 'Rex' AND LastName = 'Dasha'
WHERE FirstName = 'Magareta' AND LastName = 'Tacy';

SELECT * FROM employee_names;

-- fetching all records with records 'data'
SELECT * FROM ds_salaries
WHERE job_title LIKE '%DATA%';

-- filtering job titles using the NOT IN clause
SELECT work_year, job_title, salary_in_usd FROM ds_salaries
WHERE salary_in_usd NOT IN (120000,130000)
ORDER BY company_location DESC;

-- retrieving total salaries from individual data science roles
SELECT job_title, SUM(salary_in_usd) AS SalarySum FROM ds_salaries
GROUP BY job_title
ORDER BY SalarySum DESC;

-- checking the range of salaries (in different currencies) from 20000 to 150000
SELECT * FROM ds_salaries
WHERE salary BETWEEN 20000 AND 150000
ORDER  BY job_title ASC;

-- checking all job title present in the records
SELECT COUNT(job_title) AS CountOfJobs FROM ds_salaries;

SELECT DISTINCT job_title FROM ds_salaries;

SELECT CONCAT(FirstName," ",LastName) AS FullNames FROM employee_names;

-- fetching the maximum salary from the salary records
SELECT * FROM ds_salaries
WHERE salary_in_usd = (SELECT MAX(salary_in_usd)  FROM ds_salaries);

-- fetching the  second maximum salary from the salary records
SELECT job_title, experience_level, MAX(salary_in_usd) AS SecondHighestSalary  FROM ds_salaries
WHERE salary_in_usd < (SELECT MAX(salary_in_usd)  FROM ds_salaries);

-- fetching the minimum salary from the salary records
SELECT * FROM ds_salaries
WHERE salary_in_usd = (SELECT MIN(salary_in_usd)  FROM ds_salaries);

-- fetching the  second minimum salary from the salary records
SELECT job_title, experience_level, MIN(salary_in_usd) AS SecondLowestSalary  FROM ds_salaries
WHERE salary_in_usd < (SELECT MIN(salary_in_usd)  FROM ds_salaries);

-- joining both tables
SELECT d.*,e.* FROM employee_names e
JOIN ds_salaries d ON e.id = d.id
LIMIT 20
OFFSET 7;

CREATE VIEW TemporalTable AS SELECT id, experience_level,
 salary AS SalaryInDifferentCurrency FROM ds_salaries ;
 
 -- fetching records from custom table
 SELECT * FROM TemporalTable;
 
 -- joining Common tables to get insight on the salary  an employee makes in each data role 
 WITH CTE1 AS (SELECT id, job_title, work_year, employee_residence, company_size, salary_in_usd 
               FROM ds_salaries),
      CTE2 AS (SELECT id, CONCAT(FirstName," ", LastName) AS FullNames FROM employee_names
              ORDER BY CONCAT(FirstName," ", LastName) ASC )
      SELECT  c1.id, c2.FullNames, c1.job_title, c1.employee_residence, c1.salary_in_usd, c1.company_size FROM CTE1 c1
      JOIN CTE2 c2 ON c1.id = c2.id
      WHERE c1.company_size IN ('M','L')
      ORDER BY c2.FullNames DESC;
      
-- joining Common tables to get Average salary based on mid senior level of distinct roles from 2020 to 2021     
WITH AverageSalary AS (SELECT id, job_title, work_year,experience_level, ROUND(AVG(salary_in_usd),2) AS SalaryAverage
               FROM ds_salaries
               GROUP BY job_title
               HAVING experience_level = 'MI'),
      CTE1 AS (SELECT id, company_location FROM ds_salaries )
      SELECT  a.*, c1.company_location FROM AverageSalary a
      JOIN CTE1 c1 ON a.id = c1.id
      WHERE a.work_year < 2022
      LIMIT 10;
      
-- sequentials based on job roles
SELECT 
ROW_NUMBER() OVER (PARTITION BY job_title ORDER BY work_year ASC) AS RowNumber, 
job_title, experience_level, salary_in_usd FROM ds_salaries;

-- ranking of job roles
SELECT 
DENSE_RANK() OVER (PARTITION BY job_title ORDER BY work_year ASC) AS RankingValue, 
job_title, experience_level, salary_in_usd FROM ds_salaries;
  
SELECT 
RANK() OVER () AS RankingId, job_title, experience_level, salary_in_usd, remote_ratio,
 LAG(remote_ratio) OVER (PARTITION BY job_title) AS LagValue FROM ds_salaries; 
 
 SELECT 
MAX(salary_in_usd) - MIN(salary_in_usd) OVER () AS ChangeInSalary, job_title, experience_level,  remote_ratio
  FROM ds_salaries; 

SELECT
ROW_NUMBER() OVER (PARTITION BY job_title ORDER BY work_year ASC) AS RowNumber, job_title,
MIN(salary_in_usd) AS MinimumSalary, MAX(salary_in_usd) AS MaximumSalary, experience_level,
CASE
WHEN experience_level = 'EN' THEN 'ENTRY LEVEL'
WHEN experience_level = 'MI' THEN 'MID-SENIOR LEVEL'
WHEN experience_level = 'EN' THEN 'SENIOR LEVEL'
ELSE 'EXECUTIVE LEVEL'
END AS Position FROM ds_salaries
GROUP BY 
CASE
WHEN experience_level = 'EN' THEN 'ENTRY LEVEL'
WHEN experience_level = 'MI' THEN 'MID-SENIOR LEVEL'
WHEN experience_level = 'EN' THEN 'SENIOR LEVEL'
ELSE 'EXECUTIVE LEVEL'
END; 

--  SELECT * FROM ds_salaries
--  WHERE id=3;