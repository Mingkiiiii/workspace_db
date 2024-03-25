CREATE TABLE ���ǳ��� (
    ���ǳ�����ȣ NUMBER(3),
    ������ȣ NUMBER(3),
    �����ȣ NUMBER(3),
    ���ǽ� VARCHAR2(10),
    ���� NUMBER(3),
    �����ο� NUMBER(5),
    ��� DATE
);

CREATE TABLE ���� (
    �����ȣ NUMBER(3),
    �����̸� VARCHAR2(50),
    ���� NUMBER(3)
);

CREATE TABLE ���� (
    ������ȣ NUMBER(3),
    �����̸� VARCHAR2(20),
    ���� VARCHAR2(50),
    ���� VARCHAR2(50),
    �ּ� VARCHAR2(100)
);

CREATE TABLE �������� (
    ����������ȣ NUMBER(3),
    �й� NUMBER(10),
    �����ȣ NUMBER(3),
    ���ǽ� VARCHAR2(10),
    ���� NUMBER(3),
    ������� VARCHAR(10),
    ��� DATE 
);

CREATE TABLE �л� (
    �й� NUMBER(10),
    �̸� VARCHAR2(50),
    �ּ� VARCHAR2(100),
    ���� VARCHAR2(50),
    ������ VARCHAR2(500),
    ������� DATE,
    �б� NUMBER(3),
    ���� NUMBER
);

-- ���̺� PK ����
ALTER TABLE �л� ADD CONSTRAINT PK_�л� PRIMARY KEY (�й�);
ALTER TABLE �������� ADD CONSTRAINT PK_�������� PRIMARY KEY (����������ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_���� PRIMARY KEY (�����ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_���� PRIMARY KEY (������ȣ);
ALTER TABLE ���ǳ��� ADD CONSTRAINT PK_���ǳ��� PRIMARY KEY (���ǳ�����ȣ);

-- ���̺� FK ����
ALTER TABLE �������� ADD CONSTRAINT FK_��������_�й� FOREIGN KEY (�й�) REFERENCES �л� (�й�);
ALTER TABLE �������� ADD CONSTRAINT FK_��������_�����ȣ FOREIGN KEY (�����ȣ) REFERENCES ���� (�����ȣ);
ALTER TABLE ���ǳ��� ADD CONSTRAINT FK_���ǳ���_������ȣ FOREIGN KEY (������ȣ) REFERENCES ���� (������ȣ);
ALTER TABLE ���ǳ��� ADD CONSTRAINT FK_���ǳ���_�����ȣ FOREIGN KEY (�����ȣ) REFERENCES ���� (�����ȣ);

COMMIT;
select *
FROM �л�;

SELECT * FROM ����;
SELECT * FROM ����;
SELECT * FROM ���ǳ���;
SELECT * FROM ��������;

/* INNER JOIN �������� (��������)*/
SELECT *
FROM �л�;

SELECT *
FROM ��������;

SELECT �л�.�̸�
     , �л�.����
     , �л�.�й�
     , ��������.����������ȣ
     , ��������.�����ȣ
     , ����.�����̸�
FROM �л�, ��������, ����
WHERE �л�.�й� = ��������.�й�
AND ��������.�����ȣ=����.�����ȣ
AND �л�.�̸� = '�ּ���';


-- �л��� �������� �Ǽ��� ��ȸ�Ͻÿ�
SELECT �л�.�̸�
     , ROUND(�л�.����, 2) as ����
     , �л�.�й�
     , COUNT(��������.����������ȣ) as �����Ǽ�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
GROUP BY �л�.�̸�, �л�.����, �л�.�й�
ORDER BY 1;
/* OUTER JOIN �ܺ����� NULL���� ���Խ�Ű�� ���� ��*/
SELECT �л�.�̸�
     , ROUND(�л�.����, 2) as ����
     , �л�.�й�
     , COUNT(��������.����������ȣ) as �����Ǽ�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�(+) --null���� ���Խ�Ű�� ���� �� (+)
GROUP BY �л�.�̸�, �л�.����, �л�.�й�
ORDER BY 1;

SELECT COUNT(*)
FROM �л�, ��������;  -- cross join(�����ؾ���)
                    -- 9 * 17 = 153

SELECT COUNT(*)
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�;

--�л��� ���������� �� ���������� ����Ͻÿ�
SELECT �л�.�̸�
     , ROUND(�л�.����, 2) as ����
     , �л�.�й�
     , COUNT(��������.����������ȣ) as �����Ǽ�
     , SUM(NVL(����.����,0)) as �Ѽ�������
FROM �л�, ��������, ����
WHERE �л�.�й� = ��������.�й�(+) --null���� ���Խ�Ű�� ���� �� (+)
AND ��������.�����ȣ = ����.�����ȣ(+)
GROUP BY �л�.�̸�, ROUND(�л�.����, 2), �л�.�й�
ORDER BY 1;

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no) as īƮ���Ƚ��
     , COUNT(DISTINCT b.cart_prod) as ���Ż�ǰǰ���
     , SUM(b.cart_qty) as �ѱ��Ż�ǰ��      -- īƮ���Ƚ��, ���Ż�ǰ ǰ���, �ѱ��Ż�ǰ���� ����Ͻÿ� -- �� ���űݾ��� ����Ͻÿ�(��ǰ�ݾ��� prod_sale���)
     , SUM(c.prod_sale * b.cart_qty) as �ѱ��űݾ�
FROM member a
    ,cart b
    , prod c
WHERE a.mem_id = b.cart_member
AND b.cart_prod= c.prod_id
AND a.mem_name='������'
GROUP BY a.mem_id, a.mem_name;

-- �ܺ�����
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no) as īƮ���Ƚ��
     , COUNT(DISTINCT b.cart_prod) as ���Ż�ǰǰ���
     , SUM(NVL(b.cart_qty,0)) as �ѱ��Ż�ǰ��      -- īƮ���Ƚ��, ���Ż�ǰ ǰ���, �ѱ��Ż�ǰ���� ����Ͻÿ�
FROM member a
    ,cart b
WHERE a.mem_id = b.cart_member(+)
AND a.mem_name='Ź����'
GROUP BY a.mem_id, a.mem_name;

-- employees, jobs ���̺��� Ȱ���Ͽ� salary�� 15000 �̻��� ������ ���, �̸�, salary, �������� ����Ͻÿ�.
SELECT *
FROM employees;
SELECT *
FROM jobs;
SELECT a.employee_id
     , a.emp_name
     , a.salary
     , b.job_title
FROM employees a,
    jobs b
WHERE a.job_id = b.job_id
AND salary>15000;










/* subquery (�����ȿ� ����)
    1. ��Į�� ��������(select ��)
    2. �ζ��� �� (from��)
    3. ��ø����(where ��)
*/
-- ��Į�� ���������� ������ ��ȯ
-- ���� �� ���� ���� �������̺��� �� �Ǽ���ŭ ��ȸ�ϱ� ������(���ſ� ���̺��� ����ϸ� �����ɸ�)
-- ���Ͱ��� ��Ȳ���� ������ �̿��ϴ°� �� ����
SELECT a.emp_name
     , a.department_id  --�μ� ���̵� ��� �μ����� �ʿ��Ҷ� �μ����̵�� �μ� ���̺��� pk( ����ũ�� ������ ��ȯ)
     
     ,(SELECT department_name
       FROM departments
       WHERE department_id = a.department_id) as dep_nm
        -- ��Į�󼭺������� job_title�� ����Ͻÿ�
       ,(SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_title
FROM employees a;

-- ��ø��������(where��)
-- ������ salary ��ü��� ���� ���� ������ ����Ͻÿ�
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees) --6461.83--------------
ORDER BY 2;
-- �� �Ʒ��� ����� ������ �����Ͱ� ���� �� �ֱ� ������ ���� ������ ���°� ����
SELECT emp_name, salary
FROM employees
WHERE salary >= 6461.46556566556
ORDER BY 2;
-- �л��� ��ü��� ���� �̻��� �л������� ����Ͻÿ�
SELECT �й�, �̸�, ����, ����
FROM �л�
WHERE ���� >= (SELECT AVG(����)
              FROM �л�)
ORDER BY 1;

-- ������ ���� ���� �л��� ������ ����Ͻÿ�
SELECT �й�, �̸�, ����, ����
FROM �л�
WHERE ���� = (SELECT MAX(����)
              FROM �л�);
              
-- ���� �̷��� ���� �л��� �̸��� ����Ͻÿ�
SELECT �̸�
FROM �л�
WHERE �й� NOT IN (SELECT �й�
              FROM ��������);

-- ���ÿ� 2���̻��� �÷����� ���� �� ��ȸ
SELECT employee_id
     , emp_name
     , job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id FROM job_history);

SELECT * FROM kor_loan_status;
-- ������ �� �⵵�� �������ܾ��� ���ϴ� ������ �ۼ��� ����(kor_loan_status)
-- 2011���հ�, 2012���հ�, 2013���հ踦 ���Ͻÿ�

SELECT region, SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period >= (SELECT AVG(period)
                 FROM employees)
GROUP BY region;

SELECT region, period, SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period >= (SELECT AVG(period)
                 FROM kor_loan_status)
GROUP BY region, period;












