/*
 Company System Database sample Project
-----------------------------------------
 Concepts Used:
 - DDL
 - DML
 - Constraints
 - ALTER TABLE
 - Joins
 - Group By & Having
 - Subqueries
 - Aggregate Functions
*/

DROP DATABASE IF EXISTS CompanySystem;
CREATE DATABASE CompanySystem;
USE CompanySystem;
-- =====================================
-- Department Table
-- =====================================

CREATE TABLE IF NOT EXISTS Department (
    did INT PRIMARY KEY AUTO_INCREMENT,
    dname VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(50) DEFAULT 'Cairo'
);

-- =====================================
-- Staff Table
-- =====================================

CREATE TABLE IF NOT EXISTS Staff (
    eid INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    salary DECIMAL(10,2) CHECK (salary > 0),
    age INT CHECK (age >= 18),
    gender ENUM('M', 'F'),
    department_id INT,

    CONSTRAINT fk_did FOREIGN KEY (department_id) REFERENCES Department(did)
);

-- =====================================
-- Project Table
-- =====================================

CREATE TABLE IF NOT EXISTS Project (
    pid INT PRIMARY KEY AUTO_INCREMENT,
    pname VARCHAR(50) NOT NULL UNIQUE,
    budget DECIMAL(10,2) DEFAULT 1000
);

-- =====================================
-- Works_On Table
-- =====================================

CREATE TABLE IF NOT EXISTS Works_On (
    eid INT,
    pid INT,

    hours DECIMAL(4,2) CHECK (hours BETWEEN 1 AND 12),
    rate DECIMAL(5,2) DEFAULT 10,
    total DECIMAL(10,2) AS (hours * rate),

    PRIMARY KEY (eid, pid),

    CONSTRAINT fk_eid FOREIGN KEY (eid) REFERENCES Staff(eid),
    CONSTRAINT fk_pid  FOREIGN KEY (pid) REFERENCES Project(pid)
);

-- =====================================
-- ALTER TABLE Commands
-- =====================================

ALTER TABLE Staff
ADD COLUMN phone VARCHAR(15) UNIQUE;

ALTER TABLE Staff
MODIFY COLUMN salary DECIMAL(12,2);

ALTER TABLE Staff
DROP COLUMN email;

ALTER TABLE Staff
ADD CONSTRAINT chk_salary
CHECK (salary < 100000);

ALTER TABLE Project
MODIFY COLUMN budget DECIMAL(10,2) DEFAULT 200;

-- =====================================
-- Department Data
-- =====================================

INSERT INTO Department (dname, location)
VALUES
('Backend', 'Cairo'),
('Frontend', 'Giza'),
('AI', 'Assiut'),
('Cybersecurity', 'Alexandria'),
('Mobile Development', 'Mansoura'),
('Cloud Computing', 'Cairo'),
('Data Analysis', 'Tanta'),
('DevOps', 'Sohag');

-- =====================================
-- Staff Data
-- =====================================

INSERT INTO Staff
(full_name, salary, age, gender, phone, department_id)
VALUES
('Mohamed Mugrabhi', 12000, 20, 'M', '01012345678', 1),
('Ahmed Ali', 15000, 22, 'M', '01198765432', 2),
('Sara Mohamed', 11000, 21, 'F', '01245678901', 3),
('Omar Khaled', 18000, 24, 'M', '01077778888', 4),
('Nada Hassan', 13500, 23, 'F', '01155554444', 5),
('Youssef Adel', 16000, 25, 'M', '01233334444', 6),
('Mariam Samy', 12500, 22, 'F', '01522223333', 7),
('Ali Mahmoud', 17000, 26, 'M', '01099990000', 8),
('Habiba Tarek', 14000, 21, 'F', '01166667777', 1),
('Karim Essam', 15500, 23, 'M', '01288889999', 2);

-- =====================================
-- Project Data
-- =====================================

INSERT INTO Project (pname, budget)
VALUES
('Company System', 5000),
('AI Chatbot', 12000),
('Security Dashboard', 9000),
('E-Commerce Website', 15000),
('Hospital Management System', 18000),
('Cloud Monitoring Platform', 20000),
('Task Management App', 7000),
('Face Recognition System', 25000);

-- =====================================
-- Works_On Data
-- =====================================

INSERT INTO Works_On (eid, pid, hours, rate)
VALUES
(1, 1, 6, 20),
(2, 2, 8, 25),
(3, 3, 5, 18),
(4, 4, 7, 22),
(5, 5, 6, 19),
(6, 6, 8, 30),
(7, 7, 4, 15),
(8, 8, 9, 35),
(9, 1, 5, 17),
(10, 2, 6, 21);

-- =====================================
-- Filtering Queries
-- =====================================

SELECT *
FROM Staff
WHERE gender = 'F';

SELECT *
FROM Staff
WHERE salary BETWEEN 12000 AND 17000;

SELECT *
FROM Staff
WHERE full_name LIKE 'M%';

SELECT *
FROM Staff
WHERE full_name LIKE '%a%';

SELECT DISTINCT department_id
FROM Staff;

SELECT *
FROM Staff
LIMIT 5;

SELECT *
FROM Project
WHERE budget > 10000;

SELECT * FROM Department;

SELECT * FROM Staff;

SELECT * FROM Project;

SELECT * FROM Works_On;

SELECT full_name, salary
FROM Staff
WHERE salary > 15000;

-- =====================================
-- Aggregate Functions
-- =====================================

SELECT 
    MAX(salary) AS highest_salary
FROM Staff;

SELECT 
    MIN(salary) AS lowest_salary
FROM Staff;

SELECT 
    AVG(salary) AS average_salary
FROM Staff;

SELECT 
    COUNT(*) AS total_employees
FROM Staff;

SELECT 
    SUM(budget) AS total_budget
FROM Project;

-- =====================================
-- ORDER BY Queries
-- =====================================

SELECT *
FROM Staff
ORDER BY salary DESC;

SELECT *
FROM Project
ORDER BY budget ASC;

SELECT pname, budget
FROM Project
ORDER BY budget DESC;

-- =====================================
-- GROUP BY Queries
-- =====================================
SELECT 
    gender,
    COUNT(*) AS total
FROM Staff
GROUP BY gender;

SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM Staff
GROUP BY department_id;

SELECT 
    department_id,
    COUNT(*) AS total_staff
FROM Staff
GROUP BY department_id;

-- =====================================
-- HAVING Queries
-- =====================================

SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM Staff
GROUP BY department_id
HAVING AVG(salary) > 14000;

-- =====================================
-- Subquery Examples
-- =====================================

SELECT full_name, salary
FROM Staff
WHERE salary = (
    SELECT MAX(salary)
    FROM Staff
);

SELECT pname, budget
FROM Project
WHERE budget > (
    SELECT AVG(budget)
    FROM Project
);

-- =====================================
-- JOIN Queries
-- =====================================

SELECT 
    s.full_name,
    d.dname
FROM Staff s
JOIN Department d
ON s.department_id = d.did;

SELECT 
    s.full_name,
    p.pname,
    w.hours
FROM Works_On w
JOIN Staff s
ON w.eid = s.eid
JOIN Project p
ON w.pid = p.pid;

SELECT 
    d.dname,
    COUNT(s.eid) AS total_employees
FROM Department d
LEFT JOIN Staff s
ON d.did = s.department_id
GROUP BY d.dname;

SELECT 
    s.full_name,
    p.pname,
    w.hours,
    w.rate,
    w.total
FROM Works_On w
JOIN Staff s
ON w.eid = s.eid
JOIN Project p
ON w.pid = p.pid;

-- =====================================
-- More Advanced Queries
-- =====================================

SELECT 
    full_name,
    salary
FROM Staff
ORDER BY salary DESC
LIMIT 3;

SELECT 
    d.dname,
    MAX(s.salary) AS highest_salary
FROM Department d
JOIN Staff s
ON d.did = s.department_id
GROUP BY d.dname;

SELECT 
    p.pname,
    COUNT(w.eid) AS total_workers
FROM Project p
LEFT JOIN Works_On w
ON p.pid = w.pid
GROUP BY p.pname;

SELECT 
    full_name
FROM Staff
WHERE eid NOT IN (
    SELECT eid
    FROM Works_On
);

SELECT 
AVG(hours) AS average_hours
FROM Works_On;

-- =====================================
-- Update & Delete Examples
-- =====================================

UPDATE Staff
SET salary = salary + 1000
WHERE department_id = 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Works_On
WHERE hours < 5;

SET SQL_SAFE_UPDATES = 1;
