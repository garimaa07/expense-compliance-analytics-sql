# Enterprise Expense & Compliance Analytics System (MySQL)

## 📌 Project Overview
This project implements a **realistic enterprise-grade expense tracking and compliance system** using MySQL.  
It covers **employee expenses, approvals, policy violations, audit logs, and analytics** to support **financial control, fraud detection, and regulatory compliance**.

> Demonstrates advanced SQL skills, workflow automation, and business insights generation — perfect for Big-4 consulting or analytics interviews.

---

## 🔹 Key Features
- Fully normalized relational database for **departments, employees, expenses, approvals, and audit logs**
- **Automated policy violation detection** using triggers
- **Approval workflow** using stored procedures
- **Audit logging** for inserts and updates
- Analytics queries for:
  - High-risk employees  
  - Budget overruns  
  - Repeated violators  
  - Expense ranking using window functions  
  - Monthly trends with CTEs  
  - Outlier/fraud detection  
- Sample data included for immediate testing
- One consolidated SQL file for easy setup

---

## 🔹 Technologies Used
- **MySQL 8**  
- SQL: DDL, DML, Triggers, Stored Procedures, CTEs, Window Functions  

---

## 🔹 How to Run

1. Create the database:
```sql
CREATE DATABASE expense_compliance_db;
USE expense_compliance_db;

<img width="1440" height="362" alt="ss1" src="https://github.com/user-attachments/assets/c7eb7470-aab8-437f-a102-203df6ce4267" />





