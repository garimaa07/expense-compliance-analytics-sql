> A MySQL-based Expense Tracking, Compliance, and Analytics System with Automated Policy Enforcement and Audit Logging.
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

1. SOURCE  projecsql.SQL

---

## Query Results & Screenshots
- *High-risk employees with the most policy violations — helps identify individuals who may require additional compliance training or monitoring.*
  <img width="1440" height="362" alt="ss1" src="https://github.com/user-attachments/assets/23168ecc-be15-475f-bd6e-e9cb9565832b" />
- *All policy violations logged automatically by the system — provides a complete view of compliance issues for audit and monitoring purposes.*
  <img width="1477" height="363" alt="ss2" src="https://github.com/user-attachments/assets/94a8e588-76c1-49a0-b9f8-c0088a092c9a" />
- *Complete list of all employee expense transactions, including category, amount, date, and current approval status — forming the core dataset for compliance checks and budget analysis.*
  <img width="1484" height="374" alt="ss3" src="https://github.com/user-attachments/assets/bfe39ca7-63cf-4390-bb3a-323bc85df71d" />
- *Audit trail of all expense approval decisions, showing who approved or rejected each expense, along with timestamps and remarks — enabling transparency, accountability, and compliance tracking.*
  <img width="1572" height="379" alt="ss4" src="https://github.com/user-attachments/assets/9fa94c12-2548-49e8-a0a1-3b6112d38b58" />
- *High-risk employees ranked by total policy violations — helps management identify repeated non-compliance and target focused audits or training interventions.*
   <img width="1920" height="1020" alt="ss5" src="https://github.com/user-attachments/assets/cfd55326-c99b-411f-9537-0d065689e26b" />
- *Department-wise budget variance showing actual spend vs allocated monthly budget — highlights overspending and underutilization for financial control and planning.*
   <img width="1567" height="384" alt="ss6" src="https://github.com/user-attachments/assets/1d1d5c4f-483e-45a4-b9a5-eff3a5b08ddf" />
- *Ranks each employee’s expenses from highest to lowest using a window function — helps identify unusually high claims and individual spending patterns.*
   <img width="1519" height="389" alt="ss7" src="https://github.com/user-attachments/assets/08a8d921-e938-4442-b01e-1bded16eade0" />
- *System-generated audit trail capturing all expense insertions and status changes — ensures traceability, accountability, and regulatory compliance.*
   <img width="1548" height="388" alt="ss8" src="https://github.com/user-attachments/assets/612e9cb1-c455-4b99-a2b8-cddac8e92648" />
- *Aggregates total expenses by department and month using a CTE — enables trend analysis, seasonal monitoring, and budget planning.*
   <img width="824" height="362" alt="ss9" src="https://github.com/user-attachments/assets/85dd3b81-8d4c-47c5-a4e8-63b95d0505ec" />
- *Identifies employees whose average expense claims exceed 1.5× the company-wide average — flags potential outliers and high-risk spending behavior.*
   <img width="843" height="366" alt="ss10" src="https://github.com/user-attachments/assets/a7e3399d-796a-4349-81d8-7f63d2ffab53" />
- *Shows the count of expenses by approval status (Submitted, Approved, Rejected) — helps monitor workflow efficiency and approval bottlenecks.*
    <img width="695" height="362" alt="ss11" src="https://github.com/user-attachments/assets/ae1306e9-c65c-4e60-bfe8-d2fd07eb1099" />
- *Displays the total monetary value of all expenses that violated company policy — used to quantify financial risk and compliance impact.*
   <img width="679" height="368" alt="ss12" src="https://github.com/user-attachments/assets/a777a638-56db-4707-b01c-f44c9a201873" />
- *Shows the total number of policy violations per department — used to identify high-risk departments and target compliance improvement initiatives.*
   <img width="895" height="374" alt="ss13" src="https://github.com/user-attachments/assets/c45781d9-1cbc-450c-b9f5-fbd10ebe0469" />














