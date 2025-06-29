/*
Maurice Hazan
06/29/2025
Data inserts for all 27 tables starting with the the main foundational tables, working from Users and Companies upward, so foreign key dependencies are satisfied.
*/

Use JobBoard_DB;


INSERT INTO Users (FirstName, LastName, Email, PasswordHash, UserRole, PhoneNumber)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', 'hashed_password_1', 'Candidate', '555-123-4567'),
('Bob', 'Smith', 'bob.smith@example.com', 'hashed_password_2', 'Employer', '555-234-5678'),
('Charlie', 'Brown', 'charlie.brown@example.com', 'hashed_password_3', 'Admin', '555-345-6789');



INSERT INTO Companies (CompanyName, Industry, Website, Location, Description)
VALUES
('Tech Innovators Inc', 'Technology', 'https://techinnovators.com', 'San Francisco, CA', 'A cutting-edge tech startup.'),
('Green Energy Corp', 'Renewable Energy', 'https://greenenergy.com', 'Denver, CO', 'Leading provider of clean energy solutions.');



-- Assume Bob Smith is Employer user with UserID=2 (from above), and CompanyID=1 is Tech Innovators
INSERT INTO Employers (UserID, CompanyID, PositionTitle)
VALUES
(2, 1, 'HR Manager');



INSERT INTO Jobs (EmployerID, JobsTitle, Description, Location, EmploymentType, SalaryRange, PostedDate, JobsStatus)
VALUES
(1, 'Software Engineer', 'Develop and maintain software applications.', 'San Francisco, CA', 'Full-Time', '$80,000 - $120,000', NOW(), 'Open'),
(1, 'Product Manager', 'Lead product development teams.', 'San Francisco, CA', 'Full-Time', '$90,000 - $130,000', NOW(), 'Open');



INSERT INTO Skills (SkillName)
VALUES
('JavaScript'),
('Python'),
('Project Management'),
('Data Analysis'),
('Communication'),
('SQL'),
('React'),
('AWS');



-- Assume UserID 1 = Alice (Candidate)
INSERT INTO UserSkills (UserID, SkillID, Proficiency)
VALUES
(1, 1, 'Advanced'),   -- JavaScript
(1, 2, 'Intermediate'), -- Python
(1, 5, 'Expert');    -- Communication



-- Assume JobID 1 = Software Engineer
INSERT INTO JobSkills (JobID, SkillID)
VALUES
(1, 1),  -- JavaScript
(1, 2),  -- Python
(1, 6),  -- SQL
(1, 7);  -- React



-- Assume JobID 2 = Product Manager
INSERT INTO JobSkills (JobID, SkillID)
VALUES
(2, 3),  -- Project Management
(2, 5);  -- Communication



INSERT INTO Applications (JobID, CandidateID, ResumePath, CoverLetter, ApplicationDate, AppStatus)
VALUES
(1, 1, '/resumes/alice_johnson.pdf', 'I am excited to apply for the Software Engineer role...', NOW(), 'Submitted');



INSERT INTO Resumes (UserID, FilePath, UploadedAt, IsPrimary)
VALUES
(1, '/resumes/alice_johnson_primary.pdf', NOW(), TRUE),
(1, '/resumes/alice_johnson_old.pdf', NOW(), FALSE),
(2, '/resumes/bob_smith.pdf', NOW(), TRUE);



INSERT INTO Bookmarks (UserID, JobID, CreatedAt)
VALUES
(1, 2, NOW()),  -- Alice bookmarked Product Manager job
(2, 1, NOW());  -- Bob bookmarked Software Engineer job



INSERT INTO Messages (SenderID, ReceiverID, JobID, MessageBody, SentAt, IsRead)
VALUES
(1, 3, 1, 'Hi, I am interested in the Software Engineer position. Could you provide more info?', NOW(), FALSE),
(3, 1, 1, 'Thanks for reaching out! We are looking for someone with strong JavaScript skills.', NOW(), TRUE);



INSERT INTO Notifications (UserID, Message, NotificationType, CreatedAt, IsRead)
VALUES
(1, 'Your application for Software Engineer has been reviewed.', 'Info', NOW(), FALSE),
(2, 'New job posted: Marketing Manager.', 'Alert', NOW(), FALSE),
(3, 'Your subscription will expire in 5 days.', 'ActionRequired', NOW(), FALSE);



INSERT INTO SearchHistory (UserID, Keywords, Location, DateSearched)
VALUES
(1, 'Software Engineer, JavaScript', 'New York, NY', NOW()),
(2, 'Product Manager, Remote', 'San Francisco, CA', NOW()),
(1, 'Data Analyst', 'Chicago, IL', NOW());



INSERT INTO JobCategories (CategoryName, Description)
VALUES
('Software Engineering', 'Jobs related to software design, development, and maintenance'),
('Marketing', 'Jobs involving advertising, promotion, and sales strategy'),
('Data Science', 'Jobs focused on data analysis, modeling, and visualization'),
('Customer Support', 'Jobs handling customer inquiries and support issues'),
('Project Management', 'Jobs related to planning, executing, and managing projects');



INSERT INTO JobCategoryMapping (JobID, CategoryID)
VALUES
(1, 1),  -- Job 1 is Software Engineering
(2, 2),  -- Job 2 is Marketing
(3, 3),  -- Job 3 is Data Science
(1, 3);  -- Job 1 also tagged under Data Science



INSERT INTO Interviews (ApplicationID, InterviewDate, InterviewType, InterviewLink, IntStatus, IntNotes)
VALUES
(1, '2025-07-05 10:00:00', 'Video', 'https://zoom.us/j/1234567890', 'Scheduled', 'Initial technical interview'),
(2, '2025-07-06 14:30:00', 'Phone', NULL, 'Scheduled', 'HR phone screening'),
(3, '2025-07-07 09:00:00', 'In-Person', '123 Market St, SF, CA', 'Scheduled', 'Final in-office interview');



INSERT INTO Subscriptions (UserID, PlanName, StartDate, EndDate, IsActive, MaxJobPosts, MaxFeaturedPosts)
VALUES
(1, 'Basic Plan', '2025-07-01', '2025-10-01', TRUE, 5, 1),
(2, 'Premium Plan', '2025-06-15', '2025-12-15', TRUE, 25, 5);



INSERT INTO FeaturedJobs (JobID, StartDate, EndDate)
VALUES
(1, '2025-07-01', '2025-07-31'),
(3, '2025-07-01', '2025-08-15');



INSERT INTO EmployerProfiles (
    EmployerID, CompanyName, LogoURL, WebsiteURL, CompanyBio, Industry, Headquarters, SizeRange
)
VALUES
(1, 'TechNova Inc.', 'https://cdn.technova.com/logo.png', 'https://www.technova.com', 
 'Innovating the future through AI and software solutions.', 'Technology', 'San Francisco, CA', '201-500'),

(2, 'BrightWave Media', 'https://media.brightwave.com/logo.jpg', 'https://www.brightwave.com', 
 'Full-service digital marketing agency delivering measurable results.', 'Marketing', 'Los Angeles, CA', '51-200');



INSERT INTO EmployerReviews (
    EmployerID, ReviewerID, Rating, ReviewText, CreatedAt
)
VALUES
(1, 1, 5, 'Amazing company culture and transparent interview process.', NOW()),
(1, 2, 4, 'Good experience overall, although the process took longer than expected.', NOW()),
(2, 1, 3, 'The interviewer was not well prepared. Room for improvement.', NOW());



INSERT INTO SavedSearches (
    UserID, SearchName, SearchQuery, CreatedAt
)
VALUES
(1, 'Remote Python Jobs', '{"keywords": "Python", "location": "Remote"}', NOW()),
(2, 'Marketing in SF', '{"keywords": "Marketing", "location": "San Francisco"}', NOW());



INSERT INTO ResumeParsingResults (
    CandidateID, ParsedData, ParsedDate
)
VALUES
(1, JSON_OBJECT('name', 'Alice Johnson', 'skills', JSON_ARRAY('Python', 'SQL'), 'experience_years', 5), NOW()),
(2, JSON_OBJECT('name', 'Brian Kim', 'skills', JSON_ARRAY('Marketing', 'SEO'), 'experience_years', 3), NOW());



INSERT INTO AdminAuditLogs (
    AdminID, ActionType, TargetTable, TargetID, Details, ActionDate
)
VALUES
(3, 'DELETE_JOB', 'Jobs', 6, 'Removed expired job post due to inactivity.', NOW()),
(3, 'BAN_USER', 'Users', 7, 'User banned for repeated spam applications.', NOW());



INSERT INTO APIKeys (
    UserID, APIKeyHash, CreatedAt, ExpiresAt, IsActive
)
VALUES
(1, SHA2('apikey_user1_secret', 256), NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), TRUE),
(2, SHA2('apikey_user2_secret', 256), NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), TRUE);



INSERT INTO APIRequestLogs (
    APIKeyID, Endpoint, RequestTime, ResponseCode, RequestIP
)
VALUES
(1, '/api/jobs', NOW(), 200, '192.168.0.10'),
(1, '/api/users/1', NOW(), 403, '192.168.0.10'),
(2, '/api/applications', NOW(), 200, '10.0.0.5');



INSERT INTO SearchFilters (
    FilterName, FilterParams, CreatedBy, CreatedAt
)
VALUES
('Remote Dev Jobs', '{"employmentType":"Remote","skills":["Python","Django"]}', 1, NOW()),
('Marketing Manager - SF', '{"location":"San Francisco","title":"Manager"}', 2, NOW());



INSERT INTO WebTrafficAnalytics (
    UserID, PageURL, ReferrerURL, Action, ActionTime, UserAgent, IPAddress
)
VALUES
(1, '/jobs/1', '/home', 'view_job', NOW(), 'Mozilla/5.0 (Windows NT 10.0; Win64)', '203.0.113.1'),
(2, '/dashboard', '/login', 'login_success', NOW(), 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', '198.51.100.42');




























