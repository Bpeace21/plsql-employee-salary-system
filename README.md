# 🏢 PL/SQL Employee Salary Management System

[![Oracle Database](https://img.shields.io/badge/Oracle-Database-F80000?style=for-the-badge&logo=oracle)](https://www.oracle.com/database/)
[![PL/SQL](https://img.shields.io/badge/PL%2FSQL-Programming-FF0000?style=for-the-badge)](https://www.oracle.com/database/technologies/appdev/plsql.html)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

A comprehensive **Oracle PL/SQL** project demonstrating advanced database programming concepts including **Collections, Records, and GOTO statements** through a real-world Employee Salary Management System.

## 📋 Table of Contents

- [Features](#-features)
- [Technologies](#-Technologies)
- [Project Structure](#-project-structure)
- [Installation](#-installation & Setup)
- [Usage](#-usage)
- [Output](#-output)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Features

### 🎯 Core PL/SQL Concepts Demonstrated

| Feature | Implementation | Purpose |
|---------|----------------|---------|
| **VARRAY Collections** | Fixed-size employee ID arrays | Department employee management |
| **Nested Table Collections** | Dynamic salary history storage | Flexible data handling |
| **Associative Arrays** | Key-value employee name lookup | Fast data access |
| **Table-based Records** | `%ROWTYPE` employee records | Simplified data retrieval |
| **User-defined Records** | Custom composite structures | Complex data organization |
| **GOTO Statements** | Senior employee processing | Controlled program flow |

### 💼 Business Features

- 📊 **Employee Salary Processing**
- 🏢 **Department-wise Payroll Management**
- 🎖️ **Senior Employee Bonus Calculation**
- 📈 **Salary Statistics and Analytics**
- 📋 **Comprehensive Reporting**

## 🛠️ Technologies

**Database & Programming:**
- Oracle Database 21c
- PL/SQL Advanced Programming
- SQL*Plus Command Line

**Key Concepts Implemented:**
- Collections (VARRAY, Nested Tables, Associative Arrays)
- Records (Table-based, User-defined)
- Control Flow (GOTO Statements)

## 📁 Project Structure



## ⚡ Installation & Setup

### Prerequisites
- Oracle Database 21c (or compatible version)
- SQL*Plus command line tool
- Basic understanding of PL/SQL

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/plsql-employee-salary-system.git
   cd plsql-employee-salary-system
-- Connect to your Oracle database
sqlplus system/your_password@your_database

-- Run table creation script
@database/tables_creation.sql

-- Insert sample data
@database/sample_data.sql
-- Run the complete PL/SQL project
@plsql/main_program.sql
-- Connect to database
sqlplus system/your_password@localhost:1521/ORCL

-- Run the main program
SET SERVEROUTPUT ON;
@main_program.sql
=== PL/SQL COLLECTIONS AND RECORDS DEMONSTRATION ===
✓ VARRAY initialized with 3 elements
✓ Associative Array initialized with 3 elements

--- Processing Employees with GOTO ---
Regular: John Doe - $5000
Regular: Jane Smith - $6000
Using GOTO for senior employee
Senior: Charlie Wilson - $7000 + $1000 bonus

--- Results ---
Total Employees: 3
Total Payroll: $19000
Average Salary: $6333.33

--- Record Demonstration ---
Table-based Record: John Doe
User-defined Record: John Doe
Salary History Entries: 2

=== PROJECT COMPLETED SUCCESSFULLY ===
✓ VARRAY Collections
✓ Nested Table Collections
✓ Associative Array Collections
✓ Table-based Records
✓ User-defined Records
✓ GOTO Statements
cat > database/tables_creation.sql << 'EOF'
-- Create Employees table
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    department_id NUMBER,
    base_salary NUMBER
);

-- Create Salary History table
CREATE TABLE salary_history (
    history_id NUMBER PRIMARY KEY,
    employee_id NUMBER,
    salary_year NUMBER,
    salary_month NUMBER,
    salary_amount NUMBER,
    bonus NUMBER,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert sample data
INSERT INTO employees VALUES (1, 'John', 'Doe', 101, 5000);
INSERT INTO employees VALUES (2, 'Jane', 'Smith', 101, 6000);
INSERT INTO employees VALUES (3, 'Bob', 'Johnson', 102, 5500);
INSERT INTO employees VALUES (4, 'Alice', 'Brown', 102, 6500);
INSERT INTO employees VALUES (5, 'Charlie', 'Wilson', 101, 7000);

-- Insert salary history
INSERT INTO salary_history VALUES (1, 1, 2024, 1, 5000, 500);
INSERT INTO salary_history VALUES (2, 1, 2024, 2, 5000, 600);
INSERT INTO salary_history VALUES (3, 2, 2024, 1, 6000, 700);
INSERT INTO salary_history VALUES (4, 2, 2024, 2, 6000, 650);

COMMIT;

SELECT 'Tables created successfully!' AS message FROM dual;
