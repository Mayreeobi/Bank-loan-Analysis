Use bank_loan;

Create Table bank_loan_data(
id int Primary Key,
address_state varchar(50),	
application_type varchar(50),	
emp_length varchar(50),		
emp_title varchar(150),		
grade varchar(50),	
home_ownership varchar(50),	
issue_date date,
last_credit_pull_date date,
last_payment_date date,
loan_status	varchar(50),	
next_payment_date date,
member_id int,
purpose	varchar(50),	
sub_grade varchar(50),		
term varchar(50),	
verification_status	varchar(50),	
annual_income float,
dti	float,
installment	float,
int_rate float,	
loan_amount	int,
total_acc int,
total_payment int
);


describe bank_loan_data;

select count(id) from bank_loan_data;

-- DATA CLEANING --
# missing value #
Select Count(id), 
     Count(member_id)
From bank_loan_data
Where id IS NULL
OR member_id IS NULL;

# duplicate values
Select Count(member_id) As count_of_duplicate
From bank_loan_data
HAVING COUNT(*) > 1;

# Key Performance Indicators
-- Total loan application
SELECT 
    COUNT(id) AS Total_loan_applicants
FROM
    bank_loan_data;
-- 38,576

-- Month-to-Date (MTD) loan application
SELECT 
    COUNT(id) AS MTD_Total_loan_applications
FROM bank_loan_data
WHERE month(issue_date) = 12 AND Year(issue_date) = 2021;
-- 4,314

-- Previous Month-to-Date loan application
SELECT 
    COUNT(id) AS PMTD_Total_loan_application
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;
-- 4,035

-- Total Payment Received
SELECT 
    CONCAT('$',SUM(total_payment)) AS Total_payment_received
FROM
    bank_loan_data;
-- $473,070,933

-- Month-to-Date Total Payment Received
SELECT 
    CONCAT('$',SUM(total_payment)) AS MTD_Total_payment_received
FROM bank_loan_data
WHERE month(issue_date) = 12;
--  $58,074,380

-- Previous Month-to-Date Total Payment Received
SELECT 
    CONCAT('$',SUM(total_payment)) AS PMTD_Total_payment_amount
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;
--  $50,132,030

-- Total Loan Disbursed
SELECT 
    CONCAT('$',SUM(loan_amount)) AS Total_loan_disbursed
FROM
    bank_loan_data;
-- $435,757,075
    
-- Month-to-Date (MTD) Total loan disbursed
SELECT 
    CONCAT('$',SUM(loan_amount)) AS MTD_Total_loan_disbursed
FROM bank_loan_data
WHERE month(issue_date) = 12 AND Year(issue_date) = 2021;
-- $53,981,425

-- Previous Month-to-Date (PMTD) Total Loan Disbursed
SELECT 
    CONCAT('$',SUM(loan_amount)) AS PMTD_Total_loan_disbursed
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;
-- $47,754,825

-- Average interest rate
SELECT 
     ROUND(AVG(int_rate) * 100, 2) As Average_interest_rate
FROM 
    bank_loan_data;          -- 12.05

-- Month-to-Date (MTD) Average interest rate
SELECT 
     ROUND(AVG(int_rate) * 100, 2) As MTD_Average_interest_rate
FROM bank_loan_data
WHERE month(issue_date) = 12 AND Year(issue_date) = 2021;    -- 12.36

-- Previous Month-to-Date (PMTD) Average interest rate
SELECT 
     ROUND(AVG(int_rate) * 100, 2) As PMTD_Average_interest_rate
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;   -- 11.94

-- Average DTI (debt-to-income)
SELECT 
     ROUND(AVG(dti) * 100, 2) As Average_dti
FROM 
    bank_loan_data;          -- 13.33

-- Month-to-Date (MTD) Average DTI (debt-to-income)
SELECT 
     ROUND(AVG(dti) * 100, 2) As MTD_Average_dti
FROM bank_loan_data
WHERE month(issue_date) = 12 AND Year(issue_date) = 2021;                -- 13.67

-- Previous Month-to-Date (PMTD) Average DTI (debt-to-income)
SELECT 
     ROUND(AVG(dti) * 100, 2) As PMTD_Average_dti
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;         -- 13.3

-- Default rate
SELECT 
    ROUND((COUNT(CASE
                WHEN loan_status = 'Charged Off' THEN id
            END) / COUNT(id) * 100),
            2) AS default_rate
FROM
    bank_loan_data;    -- 13.82
 
 -- Month-to-Date (MTD) Default rate
SELECT 
    ROUND((COUNT(CASE
                WHEN loan_status = 'Charged Off' THEN id
            END) / COUNT(id) * 100),
            2) AS MTD_default_rate
FROM bank_loan_data
WHERE month(issue_date) = 12 AND Year(issue_date) = 2021;    -- 15.04

-- Previous Month-to-Date (PMTD) Default rate
SELECT 
    ROUND((COUNT(CASE
                WHEN loan_status = 'Charged Off' THEN id
            END) / COUNT(id) * 100),
            2) AS PMTD_default_rate
FROM bank_loan_data
WHERE month(issue_date) = 11 AND Year(issue_date) = 2021;    -- 13.90


# GOOD VS BAD LOAN
-- Good loan Percentage
SELECT 
    (COUNT(CASE WHEN loan_status = 'Current' OR loan_status = 'Fully Paid' THEN id END))  
    /
    COUNT(id) * 100 AS good_loan_rate
FROM 
    bank_loan_data;      -- 86.1753
    
-- Good loan applications
SELECT 
    COUNT(id) AS good_loan_applications
FROM bank_loan_data
WHERE loan_status ='Current' OR loan_status = 'Fully Paid';   -- 33,243

-- Good loan amount disbursed  
SELECT 
    CONCAT('$',SUM(CASE
        WHEN loan_status = 'Current' OR loan_status = 'Fully Paid' THEN loan_amount
        ELSE 0
    END)) AS good_loan_disbursed
FROM
    bank_loan_data; -- $370,224,850

-- Good loan payment received
SELECT 
    CONCAT('$',SUM(CASE
        WHEN loan_status = 'Current' OR loan_status = 'Fully Paid' THEN total_payment
        ELSE 0
    END)) AS good_loan_paid
FROM
    bank_loan_data; -- $435,786,170
    
SELECT SUM(total_payment) AS good_loan_paid FROM bank_loan_data
WHERE loan_status = 'Current' OR loan_status = 'Fully Paid';    -- $435,786,170
  
# Bad Loan Issued #
-- bad loan rate or percentage
SELECT 
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END))  
    /
    COUNT(id) * 100 AS bad_loan_rate
FROM 
    bank_loan_data;      -- 13.8247
    
-- Bad loan applications
SELECT 
    COUNT(id) AS bad_loan_applications
FROM bank_loan_data
WHERE loan_status ='Charged Off';   -- 5,333

-- bad loan amount disbursed    
SELECT 
    CONCAT('$',SUM(CASE
        WHEN loan_status = 'Charged Off' THEN loan_amount
        ELSE 0
    END)) AS bad_loan_disbursed
FROM
    bank_loan_data; -- $65,532,225

-- bad loan payment   
SELECT 
    CONCAT('$',SUM(total_payment)) AS unpaid_loan
FROM
    bank_loan_data
WHERE loan_status = 'Charged Off';   -- $37,284,763

    
-- Interest earned
SELECT 
    ROUND(SUM(loan_amount * int_rate / 100),2) AS total_interest_income
FROM
    bank_loan_data; -- 558005.31

-- Customer segmentation by income and loan amount
SELECT
    CASE
        WHEN annual_income >= 4000 AND annual_income < 50000 AND loan_amount <= 10000 THEN 'Low Income, Low Loan'
        WHEN annual_income >= 4000 AND annual_income < 50000 AND loan_amount > 10000 AND loan_amount <= 20000 THEN 'Low Income, Medium Loan'
        WHEN annual_income >= 4000 AND annual_income < 50000 AND loan_amount > 20000 AND loan_amount <= 35000 THEN 'Low Income, High Loan'
        WHEN annual_income >= 50000 AND annual_income <= 500000 AND loan_amount <= 10000 THEN 'Medium Income, Low Loan'
        WHEN annual_income >= 50000 AND annual_income <= 500000 AND loan_amount > 10000 AND loan_amount <= 20000 THEN 'Medium Income, Medium Loan'
        WHEN annual_income >= 50000 AND annual_income <= 500000 AND loan_amount > 20000 AND loan_amount <= 35000 THEN 'Medium Income, High Loan'
        WHEN annual_income > 500000 AND annual_income <= 6000000 AND loan_amount <= 10000 THEN 'High Income, Low Loan'
        WHEN annual_income > 500000 AND annual_income <= 6000000 AND loan_amount > 10000 AND loan_amount <= 20000 THEN 'High Income, Medium Loan'
        WHEN annual_income > 500000 AND annual_income <= 6000000 AND loan_amount > 20000 AND loan_amount <= 35000 THEN 'High Income, High Loan'
        ELSE 'Other'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM
    bank_loan_data
GROUP BY
    customer_segment
ORDER BY 
        customer_count DESC;
        
-- Regional analysis by state
SELECT 
    address_state,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    address_state
ORDER BY 
   SUM(loan_amount) DESC;


-- Loan Performance Analysis
# Calculate the average installment amount by loan status
SELECT loan_status,
       ROUND(AVG(installment),2) average_installment_amount
FROM bank_loan_data
GROUP BY loan_status;


-- Monitoring Loan Portfolio Performance
# 0verall portfolio trend
SELECT 
    MONTH(issue_date) AS Month_number,
    MONTHNAME(issue_date) AS Month_name,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY 
    Month_number;
    

-- LOAN STATUS
SELECT 
    loan_status,
    COUNT(id) AS Total_loan_applications,
    SUM(total_payment) AS Total_payment,
    SUM(loan_amount) AS Total_loan_disbursed,
	ROUND(AVG(int_rate) * 100, 3) As Avg_interest_rate,
	ROUND(AVG(dti) * 100, 3) As Average_dti
FROM 
    bank_loan_data
GROUP BY 
    loan_status;

SELECT 
    loan_status,
    SUM(total_payment) AS MTD_Total_payment,
    SUM(loan_amount) AS MTD_Total_loan_disbursed
FROM 
    bank_loan_data
WHERE Month(issue_date) = 12
GROUP BY 
loan_status;

    
-- Loan term analysis
SELECT 
    term,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    term
ORDER BY 
  term;
  
  
-- employment length analysis
SELECT 
    emp_length,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    emp_length
ORDER BY 
    COUNT(id) DESC;

-- Loan purpose analysis
SELECT 
    purpose,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    purpose
ORDER BY 
    COUNT(id) DESC;
    
-- employment length analysis
SELECT 
    emp_length,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
    emp_length
ORDER BY 
    COUNT(id) DESC;

--  home ownership analysis
SELECT 
    home_ownership,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS Total_loan_disbursed,
    SUM(total_payment) AS Total_payment
FROM 
    bank_loan_data
GROUP BY 
     home_ownership
ORDER BY 
    COUNT(id) DESC;
SELECT 
    loan_status,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loan,
    SUM(CASE WHEN loan_status != 'Charged Off' THEN 1 ELSE 0 END) AS good_loan
FROM 
    bank_loan_data
GROUP BY 
    loan_status
ORDER BY 
    loan_status DESC;



