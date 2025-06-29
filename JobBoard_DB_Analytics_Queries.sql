/*
Maurice Hazan
06/29/2025
Five analytics queries based on JobBoard_DB for key performance insights. These analytics queries can be structured as SQL views or queries that you can use to populate dashboards or reports with
*/

USE JobBoard_DB;


-- 1. Number of Jobs Posted by Each Employer

SELECT e.EmployerID, u.FirstName, u.LastName, COUNT(j.JobID) AS JobCount
FROM Employers e
JOIN Users u ON e.UserID = u.UserID
JOIN Jobs j ON e.EmployerID = j.EmployerID
GROUP BY e.EmployerID; 


-- 2. Top 5 Most Applied-to Jobs

SELECT j.JobID, j.JobsTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobID
ORDER BY ApplicationCount DESC
LIMIT 5;


-- 3. Average Rating per Employer

SELECT e.EmployerID, u.FirstName, u.LastName, AVG(er.Rating) AS AvgRating
FROM EmployerReviews er
JOIN Users u ON er.EmployerID = u.UserID
JOIN Employers e ON e.UserID = u.UserID
GROUP BY e.EmployerID;


-- 4. Daily Job Post Activity (Last 30 Days)

SELECT DATE(PostedDate) AS PostDate, COUNT(*) AS TotalJobs
FROM Jobs
WHERE PostedDate >= CURDATE() - INTERVAL 30 DAY
GROUP BY PostDate
ORDER BY PostDate;


-- 5. Application Status Breakdown

SELECT AppStatus, COUNT(*) AS Total
FROM Applications
GROUP BY AppStatus;


