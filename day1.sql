--SQL
-- DML (SELECT, INSERT, UPDATE, DELETE)
--      ��ȸ, ����, ����, ����
SELECT * --*�� ��ü �÷��� �ǹ���
FROM employees;
SELECT employee_id, emp_name
From employees;

/* table ���̺�
1. ���̺�� �÷����� �ִ� ũ���30����Ʈ
2. ���̺�� �÷������� ������ ����� �� ����
3. ���̺�� �÷������� ����, ����, _,$,#�� ����� �� ������ ù���ڴ� ���ڸ� �� �� ����
4. �����̺� ��밡���� �÷��� �ִ� 255��
*/
CREATE TABLE ex1_1(
--�ϳ��� �÷��� �ϳ��� Ÿ�԰� ����� ����
    col1 CHAR(10)
    ,col2 VARCHAR(10) --�÷��� , �� ����
    );
    
-- INSERT ������ ����
INSERT INTO ex1_1 (col1, col2)
VALUES('abc','ABC');
INSERT INTO ex1_1 (col1, col2)
VALUES('�ȳ�','������');
SELECT *
FROM ex1_1;
--���̺� ����
drop table ex1_1;
--��ɾ�� ��ҹ��ڸ� �������� ����.
--��ɾ ���� �����Ϸ��� ��ҹ��� ���
SQL�� ���� ���� �鿩���⸦ �ؼ� ���
SELECT emp_name as nm --AS(alias ��Ī)
        , hire_date hd    --�޸��� �������� �÷��� ���� ����
        , salary sa_la
        , department_id d_id
FROM employees;

--�˻� ������ �ִٸ� where�� ���
SELECT *
FROM employees
WHERE salary >= 10000;
-- �˻������� ������  AND or OR
SELECT *
FROM employees
WHERE salary >= 10000
AND salary < 11000;

SELECT *
FROM employees
WHERE department_id = 30
OR department_id = 60;

--���������� �ִٸ� order by��� ABC��������, DESC ��������
SELECT emp_name, department_id
FROM employees
WHERE department_id = 30
OR department_id = 60
ORDER BY department_id DESC;SELECT emp_name, department_id
FROM employees
WHERE department_id = 30
OR department_id = 60
--ORDER BY department_id DESC;
ORDER BY 2 DESC, 1 ASC;     --select���� �÷��� ����

-- ��Ģ����  ��밡��
SELECT emp_name
    , ROUND(salary /30,2) as �ϴ�
    , salary as ����
    , salary - salary * 0.1 as �Ǽ��ɾ�
    , salary * 12 as ����
FROM employees
ORDER BY 3 DESC; --���� �������� ����

--�� ������
SELECT * FROM employees WHERE salary = 2600; --����
SELECT * FROM employees WHERE salary <> 2600; --�����ʴ�
SELECT * FROM employees WHERE salary != 2600; --�����ʴ�
SELECT * FROM employees WHERE salary < 2600; --�̸�
SELECT * FROM employees WHERE salary > 2600; --�ʰ�
SELECT * FROM employees WHERE salary <= 2600; --����
SELECT * FROM employees WHERE salary >= 2600; --�̻�
/*PRODUCTS ���̺��� ��ǰ ���� �ݾ�(prod_min_price)�� 
30�̻� 50�̸��� ��ǰ��� ���װ�,�����ݾ��� ����Ͻÿ�
���������� ī�װ� �������� �����ݾ� ��������*/
SELECT PROD_NAME,PROD_CATEGORY, PROD_MIN_PRICE
FROM PRODUCTS
WHERE prod_min_price >= 30
AND prod_min_price < 50
ORDER BY 2 ASC, 3 DESC;