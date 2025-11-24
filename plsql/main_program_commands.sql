-- =============================================
-- MAIN PL/SQL PROGRAM
-- Employee Salary Management System
-- Demonstrating Collections, Records, and GOTO
-- =============================================

SET SERVEROUTPUT ON SIZE 1000000;

DECLARE
    -- =============================================
    -- 1. COLLECTION DECLARATIONS
    -- =============================================
    
    -- VARRAY for fixed department employee IDs (max 10 employees)
    TYPE dept_employee_ids IS VARRAY(10) OF employees.employee_id%TYPE;
    
    -- Nested Table for dynamic salary records
    TYPE salary_table IS TABLE OF salary_history.salary_amount%TYPE;
    
    -- Associative Array for employee names indexed by ID
    TYPE employee_name_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    
    -- =============================================
    -- 2. RECORD DECLARATIONS
    -- =============================================
    
    -- Table-based record for employee data
    emp_record employees%ROWTYPE;
    
    -- User-defined record for comprehensive employee info
    TYPE employee_comprehensive_rec IS RECORD (
        emp_id employees.employee_id%TYPE,
        full_name VARCHAR2(100),
        department employees.department_id%TYPE,
        base_sal employees.base_salary%TYPE,
        total_bonus NUMBER,
        salary_history salary_table,
        performance_rating VARCHAR2(20)
    );
    
    -- Cursor-based record declaration
    CURSOR emp_cursor IS 
        SELECT employee_id, first_name, last_name, department_id, base_salary 
        FROM employees 
        ORDER BY department_id, employee_id;
    
    emp_cursor_rec emp_cursor%ROWTYPE;
    
    -- =============================================
    -- 3. VARIABLE DECLARATIONS
    -- =============================================
    v_department_employees dept_employee_ids;
    v_employee_names employee_name_array;
    v_salary_data salary_table;
    v_comprehensive_emp employee_comprehensive_rec;
    v_total_payroll NUMBER := 0;
    v_employee_count NUMBER := 0;
    v_department_total NUMBER := 0;
    v_processing_error BOOLEAN := FALSE;

BEGIN
    -- =============================================
    -- PROGRAM HEADER
    -- =============================================
    DBMS_OUTPUT.PUT_LINE('🔄 =============================================');
    DBMS_OUTPUT.PUT_LINE('💼 PL/SQL EMPLOYEE SALARY MANAGEMENT SYSTEM');
    DBMS_OUTPUT.PUT_LINE('🔄 =============================================');
    DBMS_OUTPUT.PUT_LINE('🎯 Demonstrating: Collections, Records, GOTO Statements');
    DBMS_OUTPUT.PUT_LINE('📅 Execution Time: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- =============================================
    -- 4. INITIALIZE COLLECTIONS
    -- =============================================
    DBMS_OUTPUT.PUT_LINE('📦 STEP 1: INITIALIZING COLLECTIONS');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    
    <<init_arrays>>
    BEGIN
        -- Initialize VARRAY with Engineering department employees (Dept 101)
        v_department_employees := dept_employee_ids(1, 2, 5);
        
        -- Initialize associative array with employee names
        v_employee_names(1) := 'John Doe';
        v_employee_names(2) := 'Jane Smith';
        v_employee_names(5) := 'Charlie Wilson';
        v_employee_names(3) := 'Bob Johnson';
        v_employee_names(4) := 'Alice Brown';
        v_employee_names(6) := 'Diana Lee';
        v_employee_names(7) := 'Mike Taylor';
        
        DBMS_OUTPUT.PUT_LINE('✅ VARRAY initialized with ' || v_department_employees.COUNT || ' employee IDs');
        DBMS_OUTPUT.PUT_LINE('✅ Associative Array loaded with ' || v_employee_names.COUNT || ' employee names');
        
        GOTO process_employees;
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Error initializing arrays: ' || SQLERRM);
            v_processing_error := TRUE;
            GOTO error_handling;
    END init_arrays;
    
    -- =============================================
    -- 5. PROCESS EMPLOYEES USING COLLECTIONS & GOTO
    -- =============================================
    <<process_employees>>
    DECLARE
        v_emp_id NUMBER;
        v_monthly_salary NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('👥 STEP 2: PROCESSING EMPLOYEES WITH GOTO');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
        
        -- Process each employee in VARRAY
        FOR i IN 1..v_department_employees.COUNT LOOP
            v_emp_id := v_department_employees(i);
            
            -- Use GOTO for special case handling (Senior Employee)
            IF v_emp_id = 5 THEN
                DBMS_OUTPUT.PUT_LINE('🎖️  Using GOTO for Senior Employee ID: ' || v_emp_id);
                GOTO process_senior_employee;
            END IF;
            
            <<process_regular_employee>>
            BEGIN
                -- Fetch employee record using table-based record
                SELECT * INTO emp_record 
                FROM employees 
                WHERE employee_id = v_emp_id;
                
                -- Display employee information
                DBMS_OUTPUT.PUT_LINE('✅ Regular: ' || v_employee_names(v_emp_id) ||
                                   ' | Dept: ' || emp_record.department_id ||
                                   ' | Salary: $' || emp_record.base_salary);
                
                v_employee_count := v_employee_count + 1;
                v_total_payroll := v_total_payroll + emp_record.base_salary;
                v_department_total := v_department_total + emp_record.base_salary;
                
                GOTO continue_processing;
                
                <<process_senior_employee>>
                SELECT * INTO emp_record FROM employees WHERE employee_id = v_emp_id;
                DBMS_OUTPUT.PUT_LINE('⭐ Senior: ' || v_employee_names(v_emp_id) ||
                                   ' | Dept: ' || emp_record.department_id ||
                                   ' | Salary: $' || emp_record.base_salary ||
                                   ' + $1000 bonus');
                v_total_payroll := v_total_payroll + emp_record.base_salary + 1000;
                v_department_total := v_department_total + emp_record.base_salary + 1000;
                v_employee_count := v_employee_count + 1;
                GOTO continue_processing;
                
                <<continue_processing>>
                NULL; -- Continue with next employee
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('❌ Employee ID ' || v_emp_id || ' not found in database!');
                    GOTO next_employee;
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('❌ Error processing employee ' || v_emp_id || ': ' || SQLERRM);
                    GOTO next_employee;
            END;
            
            <<next_employee>>
            NULL; -- Move to next employee
        END LOOP;
        
        GOTO calculate_statistics;
    END process_employees;
    
    -- =============================================
    -- 6. CALCULATE STATISTICS
    -- =============================================
    <<calculate_statistics>>
    DECLARE
        v_average_salary NUMBER;
        v_department_avg NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('📊 STEP 3: CALCULATING PAYROLL STATISTICS');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
        
        IF v_employee_count > 0 THEN
            v_average_salary := v_total_payroll / v_employee_count;
            v_department_avg := v_department_total / v_employee_count;
            
            DBMS_OUTPUT.PUT_LINE('✅ Total Employees Processed: ' || v_employee_count);
            DBMS_OUTPUT.PUT_LINE('✅ Total Department Payroll: $' || v_total_payroll);
            DBMS_OUTPUT.PUT_LINE('✅ Department Average Salary: $' || ROUND(v_department_avg, 2));
            DBMS_OUTPUT.PUT_LINE('✅ Overall Average Salary: $' || ROUND(v_average_salary, 2));
            
            -- =============================================
            -- 7. DEMONSTRATE COMPREHENSIVE RECORD USAGE
            -- =============================================
            <<build_comprehensive_record>>
            BEGIN
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('📋 STEP 4: COMPREHENSIVE EMPLOYEE RECORD DEMO');
                DBMS_OUTPUT.PUT_LINE('-----------------------------------');
                
                -- Build table-based record
                SELECT employee_id, first_name || ' ' || last_name, department_id, base_salary
                INTO v_comprehensive_emp.emp_id, v_comprehensive_emp.full_name,
                     v_comprehensive_emp.department, v_comprehensive_emp.base_sal
                FROM employees WHERE employee_id = 1;
                
                -- Initialize nested table using BULK COLLECT
                SELECT salary_amount 
                BULK COLLECT INTO v_comprehensive_emp.salary_history
                FROM salary_history 
                WHERE employee_id = 1 
                ORDER BY salary_year, salary_month;
                
                -- Calculate total bonus using collection methods
                SELECT SUM(bonus) INTO v_comprehensive_emp.total_bonus
                FROM salary_history WHERE employee_id = 1;
                
                v_comprehensive_emp.performance_rating := 'EXCELLENT';
                
                -- Display comprehensive record information
                DBMS_OUTPUT.PUT_LINE('👤 Employee ID: ' || v_comprehensive_emp.emp_id);
                DBMS_OUTPUT.PUT_LINE('📛 Name: ' || v_comprehensive_emp.full_name);
                DBMS_OUTPUT.PUT_LINE('🏢 Department: ' || v_comprehensive_emp.department);
                DBMS_OUTPUT.PUT_LINE('💰 Base Salary: $' || v_comprehensive_emp.base_sal);
                DBMS_OUTPUT.PUT_LINE('📈 Performance: ' || v_comprehensive_emp.performance_rating);
                DBMS_OUTPUT.PUT_LINE('🎁 Total Bonus: $' || NVL(v_comprehensive_emp.total_bonus, 0));
                DBMS_OUTPUT.PUT_LINE('📅 Salary History Entries: ' || 
                                   NVL(v_comprehensive_emp.salary_history.COUNT, 0));
                
                -- Display salary history from nested table
                IF v_comprehensive_emp.salary_history.COUNT > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('📊 Salary History Details:');
                    FOR i IN 1..v_comprehensive_emp.salary_history.COUNT LOOP
                        DBMS_OUTPUT.PUT_LINE('  Month ' || i || ': $' || v_comprehensive_emp.salary_history(i));
                    END LOOP;
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('❌ Error building comprehensive record: ' || SQLERRM);
            END build_comprehensive_record;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('❌ No employees processed!');
            GOTO error_handling;
        END IF;
        
        GOTO successful_completion;
        
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('❌ Error: Cannot calculate average - no employees processed.');
            GOTO error_handling;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Error in statistics calculation: ' || SQLERRM);
            GOTO error_handling;
    END calculate_statistics;
    
    -- =============================================
    -- 8. SUCCESSFUL COMPLETION
    -- =============================================
    <<successful_completion>>
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('🎉 =============================================');
    DBMS_OUTPUT.PUT_LINE('✅ PROJECT COMPLETED SUCCESSFULLY!');
    DBMS_OUTPUT.PUT_LINE('🎉 =============================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('📚 FEATURES DEMONSTRATED:');
    DBMS_OUTPUT.PUT_LINE('   ✅ VARRAY Collections');
    DBMS_OUTPUT.PUT_LINE('   ✅ Nested Table Collections'); 
    DBMS_OUTPUT.PUT_LINE('   ✅ Associative Array Collections');
    DBMS_OUTPUT.PUT_LINE('   ✅ Table-based Records');
    DBMS_OUTPUT.PUT_LINE('   ✅ User-defined Records');
    DBMS_OUTPUT.PUT_LINE('   ✅ Cursor-based Records');
    DBMS_OUTPUT.PUT_LINE('   ✅ GOTO Statements');
    DBMS_OUTPUT.PUT_LINE('   ✅ Exception Handling');
    DBMS_OUTPUT.PUT_LINE('   ✅ Bulk Collection Operations');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('💡 Real-world business logic implemented');
    DBMS_OUTPUT.PUT_LINE('🔧 Professional error handling');
    DBMS_OUTPUT.PUT_LINE('📈 Comprehensive reporting');
    
    GOTO program_end;
    
    -- =============================================
    -- 9. ERROR HANDLING
    -- =============================================
    <<error_handling>>
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('⚠️  =============================================');
    IF v_processing_error THEN
        DBMS_OUTPUT.PUT_LINE('❌ PROCESSING TERMINATED WITH ERRORS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('⚠️  MINOR ERRORS ENCOUNTERED - PROCESSING CONTINUED');
    END IF;
    DBMS_OUTPUT.PUT_LINE('⚠️  =============================================');
    
    <<program_end>>
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('🕒 Program execution completed at: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('💥 =============================================');
        DBMS_OUTPUT.PUT_LINE('❌ UNEXPECTED ERROR OCCURRED!');
        DBMS_OUTPUT.PUT_LINE('💥 =============================================');
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Please check the database connection and table structures.');
END;
/
