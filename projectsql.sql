CREATE DATABASE expense_compliance_db;
USE expense_compliance_db;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    monthly_budget DECIMAL(12,2) NOT NULL
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INT,
    designation VARCHAR(50),
    joining_date DATE,
    status ENUM('Active','Inactive') DEFAULT 'Active',

    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


CREATE TABLE expense_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    max_allowed_amount DECIMAL(10,2)
);


CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    category_id INT NOT NULL,
    expense_date DATE NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    description VARCHAR(255),
    status ENUM('Submitted','Approved','Rejected') DEFAULT 'Submitted',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (category_id) REFERENCES expense_categories(category_id)
);


CREATE TABLE expense_approvals (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    expense_id INT NOT NULL,
    approver_id INT NOT NULL,
    approval_status ENUM('Approved','Rejected'),
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),

    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id),
    FOREIGN KEY (approver_id) REFERENCES employees(employee_id)
);


CREATE TABLE policy_violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    expense_id INT NOT NULL,
    violation_type VARCHAR(100),
    violation_description VARCHAR(255),
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id)
);


CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    record_id INT,
    action VARCHAR(20),
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_by INT,

    FOREIGN KEY (action_by) REFERENCES employees(employee_id)
);


DELIMITER $$

CREATE TRIGGER trg_policy_violation
AFTER INSERT ON expenses
FOR EACH ROW
BEGIN
    DECLARE max_limit DECIMAL(10,2);

    -- Get the allowed limit for the expense category
    SELECT max_allowed_amount
    INTO max_limit
    FROM expense_categories
    WHERE category_id = NEW.category_id;

    -- If limit exists and expense exceeds it, log violation
    IF max_limit IS NOT NULL AND NEW.amount > max_limit THEN
        INSERT INTO policy_violations (
            expense_id,
            violation_type,
            violation_description
        )
        VALUES (
            NEW.expense_id,
            'Amount Limit Exceeded',
            CONCAT(
                'Expense amount ', NEW.amount,
                ' exceeds allowed limit ', max_limit
            )
        );
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE approve_expense (
    IN p_expense_id INT,
    IN p_approver_id INT,
    IN p_status ENUM('Approved','Rejected'),
    IN p_remarks VARCHAR(255)
)
BEGIN
    UPDATE expenses
    SET status = p_status
    WHERE expense_id = p_expense_id;

    INSERT INTO expense_approvals (
        expense_id,
        approver_id,
        approval_status,
        remarks
    )
    VALUES (
        p_expense_id,
        p_approver_id,
        p_status,
        p_remarks
    );
END$$

DELIMITER ;

CREATE INDEX idx_expenses_employee ON expenses(employee_id);
CREATE INDEX idx_expenses_date ON expenses(expense_date);
CREATE INDEX idx_violations_expense ON policy_violations(expense_id);


SELECT e.employee_name,
       COUNT(v.violation_id) AS total_violations
FROM employees e
JOIN expenses ex ON e.employee_id = ex.employee_id
JOIN policy_violations v ON ex.expense_id = v.expense_id
GROUP BY e.employee_name
ORDER BY total_violations DESC;

INSERT INTO departments (department_name, monthly_budget)
VALUES 
('Finance', 200000),
('IT', 300000),
('HR', 150000),
('Sales', 250000);

INSERT INTO employees (employee_name, email, department_id, designation, joining_date)
VALUES
('Amit Sharma', 'amit@company.com', 1, 'Analyst', '2022-01-10'),
('Neha Verma', 'neha@company.com', 2, 'Developer', '2021-06-15'),
('Rahul Mehta', 'rahul@company.com', 3, 'HR Manager', '2020-03-20'),
('Pooja Singh', 'pooja@company.com', 4, 'Sales Exec', '2023-02-05');

INSERT INTO expense_categories (category_name, max_allowed_amount)
VALUES
('Travel', 5000),
('Meals', 1500),
('Office Supplies', 3000),
('Client Entertainment', 8000);


INSERT INTO expenses (employee_id, category_id, expense_date, amount, description)
VALUES
(1, 1, '2025-01-05', 4500, 'Client meeting travel'),
(2, 2, '2025-01-06', 2000, 'Team lunch'),   -- violation (over 1500)
(3, 3, '2025-01-07', 2800, 'Stationery purchase'),
(4, 4, '2025-01-08', 9000, 'Client dinner'); -- violation (over 8000)


SELECT * FROM policy_violations;


CALL approve_expense(1, 3, 'Approved', 'Looks valid');
CALL approve_expense(2, 3, 'Rejected', 'Over meal limit');
CALL approve_expense(3, 3, 'Approved', 'Approved');
CALL approve_expense(4, 3, 'Rejected', 'Over category limit');

SELECT * FROM expenses;
SELECT * FROM expense_approvals;

SELECT e.employee_name,
       COUNT(v.violation_id) AS total_violations
FROM employees e
JOIN expenses ex ON e.employee_id = ex.employee_id
JOIN policy_violations v ON ex.expense_id = v.expense_id
GROUP BY e.employee_name
ORDER BY total_violations DESC;

SELECT d.department_name,
       SUM(ex.amount) AS total_spent,
       d.monthly_budget,
       (SUM(ex.amount) - d.monthly_budget) AS budget_variance
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN expenses ex ON e.employee_id = ex.employee_id
GROUP BY d.department_name, d.monthly_budget;


SELECT e.employee_name,
       COUNT(v.violation_id) AS violations
FROM employees e
JOIN expenses ex ON e.employee_id = ex.employee_id
JOIN policy_violations v ON ex.expense_id = v.expense_id
GROUP BY e.employee_name
HAVING COUNT(v.violation_id) >= 2;

SELECT e.employee_name,
       ex.amount,
       RANK() OVER (PARTITION BY e.employee_id ORDER BY ex.amount DESC) AS expense_rank
FROM expenses ex
JOIN employees e ON ex.employee_id = e.employee_id;


DELIMITER $$

CREATE TRIGGER trg_audit_expense_insert
AFTER INSERT ON expenses
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        action_by
    )
    VALUES (
        'expenses',
        NEW.expense_id,
        'INSERT',
        NEW.employee_id
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_audit_expense_update
AFTER UPDATE ON expenses
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO audit_logs (
            table_name,
            record_id,
            action,
            action_by
        )
        VALUES (
            'expenses',
            NEW.expense_id,
            CONCAT('STATUS_CHANGED_TO_', NEW.status),
            NEW.employee_id
        );
    END IF;
END$$

DELIMITER ;

ALTER TABLE audit_logs
MODIFY action VARCHAR(50);


UPDATE expenses
SET status = 'Approved'
WHERE expense_id = 1;

SELECT * FROM audit_logs;

WITH monthly_expenses AS (
    SELECT 
        d.department_name,
        DATE_FORMAT(ex.expense_date, '%Y-%m') AS month_year,
        SUM(ex.amount) AS total_spent
    FROM expenses ex
    JOIN employees e ON ex.employee_id = e.employee_id
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name, DATE_FORMAT(ex.expense_date, '%Y-%m')
)
SELECT 
    department_name,
    month_year,
    total_spent,
    RANK() OVER (PARTITION BY department_name ORDER BY total_spent DESC) AS spend_rank
FROM monthly_expenses
ORDER BY department_name, month_year;


SELECT 
    e.employee_name,
    AVG(ex.amount) AS employee_avg_expense,
    company_avg.avg_amount AS company_avg_expense
FROM expenses ex
JOIN employees e ON ex.employee_id = e.employee_id
CROSS JOIN (
    SELECT AVG(amount) AS avg_amount
    FROM expenses
) company_avg
GROUP BY e.employee_name, company_avg.avg_amount
HAVING AVG(ex.amount) > company_avg.avg_amount * 1.5;


SELECT 
    status,
    COUNT(*) AS total_count
FROM expenses
GROUP BY status;


SELECT 
    SUM(ex.amount) AS total_violation_amount
FROM expenses ex
JOIN policy_violations v ON ex.expense_id = v.expense_id;


SELECT 
    d.department_name,
    SUM(ex.amount) AS total_spent
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN expenses ex ON e.employee_id = ex.employee_id
GROUP BY d.department_name
ORDER BY total_spent DESC
LIMIT 3;


SELECT 
    d.department_name,
    COUNT(v.violation_id) AS total_violations
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN expenses ex ON e.employee_id = ex.employee_id
LEFT JOIN policy_violations v ON ex.expense_id = v.expense_id
GROUP BY d.department_name;





















 