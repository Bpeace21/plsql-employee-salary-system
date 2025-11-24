SET SERVEROUTPUT ON;

DECLARE
    -- VARRAY Collection
    TYPE dept_employee_ids IS VARRAY(5) OF employees.employee_id%TYPE;
    
    -- Nested Table Collection  
    TYPE salary_table IS TABLE OF salary_history.salary_amount%TYPE;
    
    -- Associative Array Collection
    TYPE employee_name_array IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    
    -- Table-based Record
    emp_record employees%ROWTYPE;
    
    -- User-defined Record
    TYPE employee_comprehensive_rec IS RECORD (
        emp_id employees.employee_id%TYPE,
        full_name VARCHAR2(100),
        department employees.department_id%TYPE,
        base_sal employees.base_salary%TYPE,
        salary_history salary_table
    );
    
    -- Variables
    v_department_employees dept_employee_ids;
    v_employee_names employee_name_array;
    v_comprehensive_emp employee_comprehensive_rec;
    v_total_payroll NUMBER := 0;
    v_employee_count NUMBER := 0;
    v_emp_id NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PL/SQL COLLECTIONS AND RECORDS DEMONSTRATION ===');
    
    -- Initialize VARRAY
    v_department_employees := dept_employee_ids(1, 2, 5);
    DBMS_OUTPUT.PUT_LINE('✓ VARRAY initialized with ' || v_department_employees.COUNT || ' elements');
    
    -- Initialize Associative Array
    v_employee_names(1) := 'John Doe';
    v_employee_names(2) := 'Jane Smith'; 
    v_employee_names(5) := 'Charlie Wilson';
    DBMS_OUTPUT.PUT_LINE('✓ Associative Array initialized with ' || v_employee_names.COUNT || ' elements');
    
    -- Process employees using GOTO
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Processing Employees with GOTO ---');
    
    FOR i IN 1..v_department_employees.COUNT LOOP
        v_emp_id := v_department_employees(i);
        
        IF v_emp_id = 5 THEN
            DBMS_OUTPUT.PUT_LINE('Using GOTO for senior employee');
            GOTO process_senior;
        END IF;
        
        -- Regular employee processing
        BEGIN
            SELECT * INTO emp_record FROM employees WHERE employee_id = v_emp_id;
            DBMS_OUTPUT.PUT_LINE('Regular: ' || v_employee_names(v_emp_id) || ' - $' || emp_record.base_salary);
            v_total_payroll := v_total_payroll + emp_record.base_salary;
            v_employee_count := v_employee_count + 1;
            GOTO next_employee;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_id || ' not found');
                GOTO next_employee;
        END;
        
        <<process_senior>>
        BEGIN
            SELECT * INTO emp_record FROM employees WHERE employee_id = v_emp_id;
            DBMS_OUTPUT.PUT_LINE('Senior: ' || v_employee_names(v_emp_id) || ' - $' || emp_record.base_salary || ' + $1000 bonus');
            v_total_payroll := v_total_payroll + emp_record.base_salary + 1000;
            v_employee_count := v_employee_count + 1;
            GOTO next_employee;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Senior employee ' || v_emp_id || ' not found');
                GOTO next_employee;
        END;
        
        <<next_employee>>
        NULL;
    END LOOP;
    
    -- Calculate results
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Results ---');
    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || v_employee_count);
    DBMS_OUTPUT.PUT_LINE('Total Payroll: $' || v_total_payroll);
    
    IF v_employee_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Average Salary: $' || ROUND(v_total_payroll / v_employee_count, 2));
    END IF;
    
    -- Demonstrate Records
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Record Demonstration ---');
    
    -- Table-based record
    BEGIN
        SELECT * INTO emp_record FROM employees WHERE employee_id = 1;
        DBMS_OUTPUT.PUT_LINE('Table-based Record: ' || emp_record.first_name || ' ' || emp_record.last_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Table-based Record: Employee 1 not found');
    END;
    
    -- User-defined record with nested table
    BEGIN
        SELECT employee_id, first_name || ' ' || last_name, department_id, base_salary
        INTO v_comprehensive_emp.emp_id, v_comprehensive_emp.full_name, v_comprehensive_emp.department, v_comprehensive_emp.base_sal
        FROM employees WHERE employee_id = 1;
        
        SELECT salary_amount BULK COLLECT INTO v_comprehensive_emp.salary_history
        FROM salary_history WHERE employee_id = 1;
        
        DBMS_OUTPUT.PUT_LINE('User-defined Record: ' || v_comprehensive_emp.full_name);
        DBMS_OUTPUT.PUT_LINE('Salary History Entries: ' || v_comprehensive_emp.salary_history.COUNT);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('User-defined Record: Data not found for employee 1');
    END;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=== PROJECT COMPLETED SUCCESSFULLY ===');
    DBMS_OUTPUT.PUT_LINE('✓ VARRAY Collections');
    DBMS_OUTPUT.PUT_LINE('✓ Nested Table Collections');
    DBMS_OUTPUT.PUT_LINE('✓ Associative Array Collections'); 
    DBMS_OUTPUT.PUT_LINE('✓ Table-based Records');
    DBMS_OUTPUT.PUT_LINE('✓ User-defined Records');
    DBMS_OUTPUT.PUT_LINE('✓ GOTO Statements');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/
