/*
Maurice Hazan
06/29/2025
Five reports based on JobBoard_DB. These reports will be structured as SQL views or queries that you can use to populate dashboards or reports with.
*/

USE Jobboard_DB;


-- 1. Employer Dashboard Report

SELECT 
    e.EmployerID,
    u.FirstName,
    u.LastName,
    c.CompanyName,
    COUNT(DISTINCT j.JobID) AS TotalJobsPosted,
    COUNT(DISTINCT a.ApplicationID) AS TotalApplicationsReceived,
    ROUND(AVG(er.Rating), 2) AS AverageRating,
    s.PlanName,
    s.IsActive AS SubscriptionActive
FROM Employers e
JOIN Users u ON e.UserID = u.UserID
JOIN Companies c ON e.CompanyID = c.CompanyID
LEFT JOIN Jobs j ON e.EmployerID = j.EmployerID
LEFT JOIN Applications a ON j.JobID = a.JobID
LEFT JOIN EmployerReviews er ON er.EmployerID = u.UserID
LEFT JOIN Subscriptions s ON s.UserID = u.UserID
GROUP BY 
    e.EmployerID, u.FirstName, u.LastName, c.CompanyName, s.PlanName, s.IsActive;
    
-- 2. Candidate Summary Report

SELECT 
    u.UserID,
    u.FirstName,
    u.LastName,
    COUNT(DISTINCT a.ApplicationID) AS TotalApplications,
    COUNT(DISTINCT i.InterviewID) AS TotalInterviewsScheduled,
    COUNT(DISTINCT js.JobID) AS MatchedJobsBySkills
FROM Users u
LEFT JOIN Applications a ON u.UserID = a.CandidateID
LEFT JOIN Interviews i ON a.ApplicationID = i.ApplicationID
LEFT JOIN UserSkills us ON u.UserID = us.UserID
LEFT JOIN JobSkills js ON us.SkillID = js.SkillID
WHERE u.UserRole = 'Candidate'
GROUP BY u.UserID;

-- 3. Admin Overview Report

SELECT 
    (SELECT COUNT(*) FROM Users WHERE UserRole = 'Candidate') AS TotalCandidates,
    (SELECT COUNT(*) FROM Users WHERE UserRole = 'Employer') AS TotalEmployers,
    (SELECT COUNT(*) FROM Jobs WHERE JobsStatus = 'Open') AS OpenJobs,
    (SELECT COUNT(*) FROM Jobs WHERE JobsStatus = 'Closed') AS ClosedJobs,
    (SELECT COUNT(*) FROM Jobs WHERE JobsStatus = 'Filled') AS FilledJobs,
    (SELECT COUNT(*) FROM AdminAuditLogs) AS TotalAdminActions
;

-- 4. Subscription Revenue Report

SELECT 
    PlanName,
    COUNT(*) AS ActiveSubscriptions,
    SUM(CASE WHEN IsActive THEN MaxJobPosts ELSE 0 END) AS TotalJobPostQuota,
    SUM(CASE WHEN IsActive THEN MaxFeaturedPosts ELSE 0 END) AS TotalFeaturedQuota,
    SUM(CASE 
        WHEN IsActive AND EndDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY 
        THEN 1 ELSE 0 
    END) AS ExpiringSoon
FROM Subscriptions
WHERE IsActive = TRUE
GROUP BY PlanName;

-- You can add estimated revenue if you assign prices to each plan.

-- 5. Traffic Analytics Report

SELECT 
    DATE(PostedDate) AS PostDate,
    COUNT(*) AS TotalJobsPosted,
    SUM(CASE WHEN JobsStatus = 'Open' THEN 1 ELSE 0 END) AS OpenJobs,
    SUM(CASE WHEN JobsStatus = 'Closed' THEN 1 ELSE 0 END) AS ClosedJobs,
    SUM(CASE WHEN JobsStatus = 'Filled' THEN 1 ELSE 0 END) AS FilledJobs
FROM Jobs
GROUP BY DATE(PostedDate)
ORDER BY PostDate DESC
LIMIT 30;

