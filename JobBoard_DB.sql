/*
Maurice Hazan
06/29/2025

JobBoard_DB is a fully normalized MySQL relational database system for managing a modern job board platform. 
It supports core functionality for users (candidates, employers, admins), job postings, applications, interviews, 
messaging, subscriptions, analytics, and more.

Tehnical skills: SQL (core of the entire project), Database Design, MySQL, Data Modeling, Relational Databases, Database Normalization
Tools & Platforms: GitHub, VS Code, Markdown, ER diagrams
Analytics & Reporting: Data Analysis, SQL Reporting, Business Intelligence, 
Development Practices: Full Stack Development (Database layer), Software Documentation, Project Management, Job Board systems, HR Tech

Features: 	- User roles: Candidates, Employers, and Admins
			- Resume uploads and parsing
			- Employer profiles and reviews
			- Job postings with skill and category mapping
			- Applications and interview scheduling
			- Real-time messaging between users
			- Notifications and saved searches
			- API keys and request logging
			- Web traffic analytics
			- Subscription plans and featured jobs
			- Admin audit logs for accountability

Database structure: The system includes **27 interrelated tables**, grouped into the following modules: 
1) Users & Access Control
2) Jobs & Applications
3) Scheduling & Communication
4) Subscriptions & Monetization
5) Search & Analytics	
6) Sample Reports

The database includes tested views and queries for:

- Top-performing employers
- Most in-demand job categories
- Candidate application history
- Subscription plan analytics
- Job posting activity trends

*/

CREATE DATABASE JobBoard_DB;

Use JobBoard_DB;

-- ==========================================================================
-- ******************** Users table *****************************************
-- ==========================================================================

CREATE TABLE Users (
    UserID              INT PRIMARY KEY AUTO_INCREMENT,
    FirstName           VARCHAR(50),
    LastName            VARCHAR(50),
    Email               VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash        VARCHAR(255) NOT NULL,
    UserRole            ENUM('Candidate', 'Employer', 'Admin') NOT NULL,
    PhoneNumber         VARCHAR(20),
    CreatedAt           DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================================================
-- ******************** Companies table **************************************
-- ===========================================================================

CREATE TABLE Companies (
    CompanyID           INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName         VARCHAR(100) NOT NULL,
    Industry            VARCHAR(100),
    Website             VARCHAR(100),
    Location            VARCHAR(100),
    Description         TEXT
);

-- ===========================================================================
-- ******************** Employers table **************************************
-- ===========================================================================

CREATE TABLE Employers (
    EmployerID          INT PRIMARY KEY AUTO_INCREMENT,
    UserID              INT NOT NULL,
    CompanyID           INT NOT NULL,
    PositionTitle       VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- ===========================================================================
-- ******************** Jobs table *******************************************
-- ===========================================================================

CREATE TABLE Jobs (
    JobID               INT PRIMARY KEY AUTO_INCREMENT,
    EmployerID          INT NOT NULL,
    JobsTitle           VARCHAR(100),
    Description         TEXT,
    Location            VARCHAR(100),
    EmploymentType      ENUM('Full-Time', 'Part-Time', 'Contract', 'Internship', 'Remote'),
    SalaryRange         VARCHAR(50),
    PostedDate          DATETIME DEFAULT CURRENT_TIMESTAMP,
    JobsStatus          ENUM('Open', 'Closed', 'Filled') DEFAULT 'Open',
    FOREIGN KEY (EmployerID) REFERENCES Employers(EmployerID)
);

-- ===========================================================================
-- ******************** Applications table ***********************************
-- ===========================================================================

CREATE TABLE Applications (
    ApplicationID       INT PRIMARY KEY AUTO_INCREMENT,
    JobID               INT NOT NULL,
    CandidateID         INT NOT NULL, -- references Users table
    ResumePath          VARCHAR(255),
    CoverLetter         TEXT,
    ApplicationDate     DATETIME DEFAULT CURRENT_TIMESTAMP,
    AppStatus           ENUM('Submitted', 'Reviewed', 'Interviewing', 'Rejected', 'Hired') DEFAULT 'Submitted',
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (CandidateID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** Resumes table ***************************************
-- ==========================================================================

CREATE TABLE Resumes (
    ResumeID            INT PRIMARY KEY AUTO_INCREMENT,
    UserID              INT NOT NULL,
    FilePath            VARCHAR(255),
    UploadedAt          DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsPrimary           BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** Skills table ****************************************
-- ==========================================================================

CREATE TABLE Skills (
    SkillID       		INT PRIMARY KEY AUTO_INCREMENT,
    SkillName      		VARCHAR(100) UNIQUE NOT NULL
);

-- ==========================================================================
-- ******************** UserSkills table ************************************
-- ==========================================================================

CREATE TABLE UserSkills (
    UserID         		INT,
    SkillID        		INT,
    Proficiency    		ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert'),
    PRIMARY KEY (UserID, SkillID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- =========================================================================
-- ******************** JobSkills table ************************************
-- =========================================================================

CREATE TABLE JobSkills (
    JobID          		INT,
    SkillID        		INT,
    PRIMARY KEY (JobID, SkillID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- =========================================================================
-- ******************** Bookmarks table ************************************
-- =========================================================================

CREATE TABLE Bookmarks (
    BookmarkID     		INT PRIMARY KEY AUTO_INCREMENT,
    UserID         		INT,
    JobID          		INT,
    CreatedAt      		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);

-- =========================================================================
-- ******************** Messages table *************************************
-- =========================================================================

CREATE TABLE Messages (
    MessageID      		INT PRIMARY KEY AUTO_INCREMENT,
    SenderID      		INT NOT NULL,
    ReceiverID     		INT NOT NULL,
    JobID          		INT,
    MessageBody    		TEXT,
    SentAt        		DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead        		BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (SenderID) REFERENCES Users(UserID),
    FOREIGN KEY (ReceiverID) REFERENCES Users(UserID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);

-- =========================================================================
-- ******************** Notifications table ********************************
-- =========================================================================

CREATE TABLE Notifications (
    NotificationID     INT PRIMARY KEY AUTO_INCREMENT,
    UserID             INT NOT NULL,
    Message            VARCHAR(255),
    NotificationType   ENUM('Info', 'Alert', 'ActionRequired'),
    CreatedAt          DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead             BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =========================================================================
-- ******************** Searchhistory table ********************************
-- =========================================================================

CREATE TABLE SearchHistory (
    SearchID           INT PRIMARY KEY AUTO_INCREMENT,
    UserID             INT,
    Keywords           VARCHAR(255),
    Location           VARCHAR(100),
    DateSearched       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =========================================================================
-- ******************** JobCategories table ********************************
-- =========================================================================

CREATE TABLE JobCategories (
    CategoryID     	   INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName       VARCHAR(100) NOT NULL UNIQUE,
    Description        TEXT
);

-- =========================================================================
-- ******************** JobCategoryMapping table ***************************
-- =========================================================================

CREATE TABLE JobCategoryMapping (
    JobID         		INT,
    CategoryID    		INT,
    PRIMARY KEY (JobID, CategoryID),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (CategoryID) REFERENCES JobCategories(CategoryID)
);

-- =========================================================================
-- ******************** Interviews table ***********************************
-- =========================================================================

CREATE TABLE Interviews (
    InterviewID    		INT PRIMARY KEY AUTO_INCREMENT,
    ApplicationID  		INT,
    InterviewDate  		DATETIME NOT NULL,
    InterviewType  		ENUM('Phone', 'Video', 'In-Person'),
    InterviewLink  		VARCHAR(255),  -- Zoom/Meet link or address
    IntStatus     		ENUM('Scheduled', 'Completed', 'Cancelled'),
    IntNotes       		TEXT,
    FOREIGN KEY (ApplicationID) REFERENCES Applications(ApplicationID)
);

-- =========================================================================
-- ******************** Subscriptions table ********************************
-- =========================================================================

CREATE TABLE Subscriptions (
    SubscriptionID   	INT PRIMARY KEY AUTO_INCREMENT,
    UserID           	INT, -- Employer user
    PlanName         	VARCHAR(100),
    StartDate        	DATE,
    EndDate          	DATE,
    IsActive         	BOOLEAN DEFAULT TRUE,
    MaxJobPosts      	INT,
    MaxFeaturedPosts 	INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =========================================================================
-- ******************** FeaturedJobs table *********************************
-- =========================================================================

CREATE TABLE FeaturedJobs (
    JobID       	 	INT PRIMARY KEY,
    StartDate    		DATE,
    EndDate      		DATE,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);

-- =========================================================================
-- ******************** EmployerProfiles table *****************************
-- =========================================================================

CREATE TABLE EmployerProfiles (
    EmployerID        	INT PRIMARY KEY,
    CompanyName       	VARCHAR(255),
    LogoURL           	VARCHAR(255),
    WebsiteURL        	VARCHAR(255),
    CompanyBio       	TEXT,
    Industry          	VARCHAR(100),
    Headquarters      	VARCHAR(100),
    SizeRange         	VARCHAR(50), -- e.g., '51-200', '5000+'
    FOREIGN KEY (EmployerID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** EmployerReviews table *******************************
-- ==========================================================================

CREATE TABLE EmployerReviews (
    ReviewID       		INT PRIMARY KEY AUTO_INCREMENT,
    EmployerID     		INT,
    ReviewerID     		INT,
    Rating         		INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText     		TEXT,
    CreatedAt     		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EmployerID) REFERENCES Users(UserID),
    FOREIGN KEY (ReviewerID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** SavedSearches table *********************************
-- ==========================================================================

CREATE TABLE SavedSearches (
    SearchID       		INT PRIMARY KEY AUTO_INCREMENT,
    UserID         		INT,
    SearchName     		VARCHAR(100),
    SearchQuery    		TEXT,  -- JSON or serialized query parameters
    CreatedAt      		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** ResumeParsingResults table **************************
-- ==========================================================================

CREATE TABLE ResumeParsingResults (
    ParsingID      		INT PRIMARY KEY AUTO_INCREMENT,
    CandidateID    		INT,
    ParsedData     		JSON,
    ParsedDate     		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CandidateID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** AdminAuditLogs table ********************************
-- ==========================================================================

CREATE TABLE AdminAuditLogs (
    LogID         		INT PRIMARY KEY AUTO_INCREMENT,
    AdminID       		INT,
    ActionType    		VARCHAR(50), -- e.g. 'DELETE_JOB', 'BAN_USER'
    TargetTable   		VARCHAR(50),
    TargetID      		INT,
    Details       		TEXT,
    ActionDate    		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AdminID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** APIKeys table ***************************************
-- ==========================================================================

CREATE TABLE APIKeys (
    KeyID 				INT PRIMARY KEY AUTO_INCREMENT,
    UserID 				INT NOT NULL,
    APIKeyHash 			VARCHAR(255) NOT NULL,
    CreatedAt			DATETIME DEFAULT CURRENT_TIMESTAMP,
    ExpiresAt 			DATETIME,
    IsActive 			BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** APIRequestLogs table ********************************
-- ==========================================================================

CREATE TABLE APIRequestLogs (
    RequestID     		INT PRIMARY KEY AUTO_INCREMENT,
    APIKeyID      		INT,
    Endpoint      		VARCHAR(255),
    RequestTime   		DATETIME DEFAULT CURRENT_TIMESTAMP,
    ResponseCode  		INT,
    RequestIP     		VARCHAR(45),
    FOREIGN KEY (APIKeyID) REFERENCES APIKeys(KeyID)
);

-- ==========================================================================
-- ******************** SearchFilters table *********************************
-- ==========================================================================

CREATE TABLE SearchFilters (
    FilterID      		INT PRIMARY KEY AUTO_INCREMENT,
    FilterName    		VARCHAR(100),
    FilterParams  		JSON,
    CreatedBy     		INT, -- UserID or NULL for system defaults
    CreatedAt     		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- ==========================================================================
-- ******************** WebTrafficAnalytics table ***************************
-- ==========================================================================

CREATE TABLE WebTrafficAnalytics (
    AnalyticsID   		INT PRIMARY KEY AUTO_INCREMENT,
    UserID       		INT,
    PageURL      		VARCHAR(255),
    ReferrerURL  		VARCHAR(255),
    Action       		VARCHAR(100),
    ActionTime   		DATETIME DEFAULT CURRENT_TIMESTAMP,
    UserAgent    		TEXT,
    IPAddress    		VARCHAR(45),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


