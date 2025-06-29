/*
Maurice Hazan
06/29/2025
Some useful sample queries to test JobBoard_DB data and explore relationships across tables
*/

Use JobBoard_DB;


-- 1. List all open jobs with company name, location, posted date, and salary range

SELECT 
    j.JobID,
    j.JobsTitle,
    c.CompanyName,
    j.Location,
    j.PostedDate,
    j.SalaryRange,
    j.JobsStatus
FROM Jobs j
JOIN Employers e ON j.EmployerID = e.EmployerID
JOIN Companies c ON e.CompanyID = c.CompanyID
WHERE j.JobsStatus = 'Open'
ORDER BY j.PostedDate DESC;


-- 2. Show all skills required for a specific job (e.g., JobID = 1)

SELECT 
    s.SkillName
FROM JobSkills js
JOIN Skills s ON js.SkillID = s.SkillID
WHERE js.JobID = 1;


-- 3. List all candidates who applied to a specific job, with application status

SELECT 
    u.UserID,
    CONCAT(u.FirstName, ' ', u.LastName) AS CandidateName,
    a.ApplicationDate,
    a.AppStatus
FROM Applications a
JOIN Users u ON a.CandidateID = u.UserID
WHERE a.JobID = 1
ORDER BY a.ApplicationDate DESC;


-- 4. Get average rating and review count for each employer

SELECT 
    u.UserID AS EmployerUserID,
    c.CompanyName,
    AVG(er.Rating) AS AvgRating,
    COUNT(er.ReviewID) AS ReviewCount
FROM EmployerReviews er
JOIN Users u ON er.EmployerID = u.UserID
JOIN Employers e ON e.UserID = u.UserID
JOIN Companies c ON e.CompanyID = c.CompanyID
GROUP BY u.UserID, c.CompanyName
ORDER BY AvgRating DESC;


-- 5. Find jobs posted by a specific employer (e.g., EmployerID = 1) with categories

SELECT 
    j.JobID,
    j.JobsTitle,
    GROUP_CONCAT(jc.CategoryName SEPARATOR ', ') AS Categories,
    j.Location,
    j.PostedDate,
    j.SalaryRange
FROM Jobs j
LEFT JOIN JobCategoryMapping jcm ON j.JobID = jcm.JobID
LEFT JOIN JobCategories jc ON jcm.CategoryID = jc.CategoryID
WHERE j.EmployerID = 1
GROUP BY j.JobID, j.JobsTitle, j.Location, j.PostedDate, j.SalaryRange;


-- 6. Show messages between two users (e.g., UserID 1 and UserID 3)

SELECT 
    m.MessageID,
    m.SenderID,
    CONCAT(u1.FirstName, ' ', u1.LastName) AS SenderName,
    m.ReceiverID,
    CONCAT(u2.FirstName, ' ', u2.LastName) AS ReceiverName,
    m.MessageBody,
    m.SentAt,
    m.IsRead
FROM Messages m
JOIN Users u1 ON m.SenderID = u1.UserID
JOIN Users u2 ON m.ReceiverID = u2.UserID
WHERE (m.SenderID = 1 AND m.ReceiverID = 3) 
   OR (m.SenderID = 3 AND m.ReceiverID = 1)
ORDER BY m.SentAt;


-- 7. List user’s bookmarked jobs with job and company info (e.g., UserID = 2)

SELECT 
    b.BookmarkID,
    j.JobID,
    j.JobsTitle,
    c.CompanyName,
    j.Location,
    b.CreatedAt
FROM Bookmarks b
JOIN Jobs j ON b.JobID = j.JobID
JOIN Employers e ON j.EmployerID = e.EmployerID
JOIN Companies c ON e.CompanyID = c.CompanyID
WHERE b.UserID = 2
ORDER BY b.CreatedAt DESC;


-- 8. Show subscriptions active for employers, with plan details

SELECT 
    u.UserID,
    CONCAT(u.FirstName, ' ', u.LastName) AS EmployerName,
    s.PlanName,
    s.StartDate,
    s.EndDate,
    s.IsActive,
    s.MaxJobPosts,
    s.MaxFeaturedPosts
FROM Subscriptions s
JOIN Users u ON s.UserID = u.UserID
WHERE s.IsActive = TRUE
ORDER BY s.StartDate DESC;

