-- Create Database
CREATE DATABASE EmployeeManagement;
GO
USE EmployeeManagement;
GO

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);
GO

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    HireDate DATE NOT NULL,
    JobTitle VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);
GO

-- Create Salaries Table (Historical Salary Records)
CREATE TABLE Salaries (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    EffectiveDate DATE NOT NULL,
    CONSTRAINT FK_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);
GO

-- Insert Sample Data into Departments
INSERT INTO Departments (DepartmentName) VALUES 
('HR'), ('IT'), ('Finance'), ('Marketing');
GO

-- Insert Sample Data into Employees
INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, HireDate, JobTitle) VALUES
('Alice', 'Johnson', 1, 55000.00, '2020-06-15', 'HR Manager'),
('Bob', 'Smith', 2, 75000.00, '2018-09-23', 'Software Engineer'),
('Charlie', 'Brown', 3, 68000.00, '2019-03-11', 'Financial Analyst'),
('Diana', 'Clark', 4, 62000.00, '2021-05-20', 'Marketing Specialist');
GO

-- Insert Sample Data into Salaries (Historical Salary Records)
INSERT INTO Salaries (EmployeeID, Salary, EffectiveDate) VALUES
(1, 50000.00, '2019-06-15'),
(1, 55000.00, '2020-06-15'),
(2, 70000.00, '2017-09-23'),
(2, 75000.00, '2018-09-23'),
(3, 65000.00, '2018-03-11'),
(3, 68000.00, '2019-03-11'),
(4, 60000.00, '2020-05-20'),
(4, 62000.00, '2021-05-20');
GO

-- Queries for Analysis

-- 1. List All Employees with Department Names
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, e.JobTitle, e.Salary
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- 2. Find Employees Hired After 2020
SELECT EmployeeID, FirstName, LastName, HireDate 
FROM Employees 
WHERE HireDate > '2020-01-01';
GO

-- 3. Average Salary by Department
SELECT d.DepartmentName, AVG(e.Salary) AS AvgSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
GO

-- 4. Get Salary History for an Employee
SELECT e.FirstName, e.LastName, s.Salary, s.EffectiveDate
FROM Salaries s
JOIN Employees e ON s.EmployeeID = e.EmployeeID
WHERE e.EmployeeID = 1
ORDER BY s.EffectiveDate DESC;
GO

-- 5. Count of Employees per Department
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
GO

-- 6. Get the Highest-Paid Employee in Each Department
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (SELECT MAX(Salary) FROM Employees WHERE DepartmentID = e.DepartmentID);
GO
