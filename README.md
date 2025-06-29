# JobBoard_DB

**JobBoard_DB** is a fully normalized MySQL relational database system for managing a modern job board platform. It supports core functionality for users (candidates, employers, admins), job postings, applications, interviews, messaging, subscriptions, analytics, and more.

## 🚀 Features

- User roles: Candidates, Employers, and Admins
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

## 🧱 Database Structure

The system includes **27 interrelated tables**, grouped into the following modules:

### 🔐 Users & Access Control
- `Users`
- `Employers`
- `Companies`
- `EmployerProfiles`
- `APIKeys`
- `AdminAuditLogs`

### 📝 Jobs & Applications
- `Jobs`
- `Applications`
- `Resumes`
- `Skills`
- `UserSkills`
- `JobSkills`
- `JobCategories`
- `JobCategoryMapping`

### 📅 Scheduling & Communication
- `Interviews`
- `Messages`
- `Notifications`

### 💼 Subscriptions & Monetization
- `Subscriptions`
- `FeaturedJobs`
- `EmployerReviews`

### 🔍 Search & Analytics
- `SearchHistory`
- `SavedSearches`
- `SearchFilters`
- `WebTrafficAnalytics`
- `ResumeParsingResults`
- `APIRequestLogs`

## 📊 Sample Reports

The database includes tested views and queries for:

- Top-performing employers
- Most in-demand job categories
- Candidate application history
- Subscription plan analytics
- Job posting activity trends

## 🛠️ Tech Stack

- **MySQL** 8.x
- Compatible with **Flask**, **Node.js**, or any backend API
- Frontend/UI can be powered by React, Vue, or simple HTML/CSS

## 💾 Sample Data

Test data was inserted for all tables, ensuring full referential integrity. Data validation queries and analytics were used to confirm consistency.

## 📌 Author
Created by: Maurice Hazan on June 29, 2025

📧 [mauriceh01@hotmail.com](mailto:mauriceh01@hotmail.com)     

🌉 [LinkedIn](https://linkedin.com/in/mohazan)     

🔗 [GitHub](https://github.com/mauriceh01)       



## 📁 Getting Started

To install the database locally:

```sql
CREATE DATABASE JobBoard_DB;
-- Then run the SQL schema and insert files
```
📝 License
This project is released under the MIT License.



