/*  �����Լ� ��� �����͸� Ư�� �׷����� ���� ���� 
    �׷쿡 ���� ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�.
*/
SELECT COUNT(*)    --null����
     , COUNT(department_id) --default ALL
     , COUNT(ALL department_id) -- �ߺ�����, null X
     , COUNT(DISTINCT department_id) -- �ߺ�����
     , COUNT(employee_id)
FROM employees;

SELECT COUNT(mem_id)
     , COUNT(*)
FROM member;
SELECT SUM(salary) as �հ�
     , ROUND(AVG(salary)) as ���
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , COUNT(employee_id) as ������
--     employee_id �����Լ� ����� ���Ұ���(����)
FROM employees;
--�μ��� ���� <-- �׷��� ��� �μ�
SELECT department_id
     , SUM(salary) as �հ�
     , ROUND(AVG(salary)) as ���
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , COUNT(employee_id) as ������
FROM employees
GROUP BY department_id
ORDER BY 1;
-- 30,60,90 �μ��� ����
SELECT department_id
     , SUM(salary) as �հ�
     , ROUND(AVG(salary)) as ���
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , COUNT(employee_id) as ������
FROM employees
WHERE department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;


-- member ȸ���� ������ ���ϸ����� �հ�, ���, �ִ�, �ּ� ���� ȸ������ ����Ͻÿ�
SELECT mem_job
    , SUM(mem_mileage) as ���ϸ����հ�
    , ROUND(AVG(mem_mileage)) as ���
    , MAX(mem_mileage) as �ִ�
    , MIN(mem_mileage) as �ּ�
    , COUNT(mem_mileage) as ȸ����
FROM member
GROUP BY mem_job
ORDER BY 4 DESC;

-- kor_loan_status ���̺� loan_jan_amt �÷��� Ȱ���Ͽ�
-- 2013�⵵ �Ⱓ�� �� ���� �ܾ��� ����Ͻÿ�
SELECT *
FROM kor_loan_status;

SELECT period
     , SUM(loan_jan_amt) AS ���ܾ�
FROM kor_loan_status
WHERE PERIOD BETWEEN '20130101' AND '20131231'
GROUP BY period
ORDER BY 1;

-- �Ⱓ��, ������, ���� ���հ踦 ����Ͻÿ�
SELECT period
     , region
     , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY period, region
ORDER BY 1;
-- �⵵��, ������ �����հ�
SELECT SUBSTR(period, 1, 4) as �⵵
     , region
     , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY SUBSTR(period, 1, 4), region
ORDER BY 1;


-- employees ��������  �Ի�⵵(hire_date)�� �������� ����Ͻÿ�
SELECT TO_CHAR(hire_date, 'YYYY') as �⵵
     , COUNT(*) as ������
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY �⵵;

-- ���� �����Ϳ� ���ؼ� �˻������� ����Ϸ��� HAVING ���
-- �Ի������� 10�� �̻��� �⵵�� ������ ���
SELECT TO_CHAR(hire_date, 'YYYY') as �⵵
     , COUNT(*) as ������
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(*) >= 10
ORDER BY �⵵;

/* member ���̺��� Ȱ���Ͽ� ������ ���ϸ��� ��ձݾ��� ���Ͻÿ�
   (�Ҽ��� 2° �ڸ����� �ݿø��Ͽ� ���)
   (1) ���� ��ո��ϸ��� ��������
   (2) ��� ���ϸ����� 3000�̻��� �����͸� ���
*/


SELECT mem_job, ROUND(AVG(mem_mileage), 2) AS ��ո��ϸ���
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000
ORDER BY AVG(mem_mileage) DESC;


-- customers ȸ���� ��ü ȸ����, ���� ȸ����, ���� ȸ������ ����Ͻÿ�
SELECT 
    COUNT(*) AS ��üȸ����,
    SUM(CASE WHEN cust_gender = 'M' THEN 1 ELSE 0 END) AS ����ȸ����,
    SUM(CASE WHEN cust_gender = 'F' THEN 1 ELSE 0 END) AS ����ȸ����
FROM 
customers;



