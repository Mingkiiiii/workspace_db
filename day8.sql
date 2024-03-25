
ALTER TABLE �л� ADD CONSTRAINT PK_�л�_�й� PRIMARY KEY (�й�);
ALTER TABLE �������� ADD CONSTRAINT PK_��������_����������ȣ PRIMARY KEY (����������ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_���񳻿�_�����ȣ PRIMARY KEY (�����ȣ);
ALTER TABLE ���� ADD CONSTRAINT PK_����_������ȣ PRIMARY KEY (������ȣ);

ALTER TABLE �������� 
ADD CONSTRAINT FK_�л�_�й� FOREIGN KEY(�й�)
REFERENCES �л�(�й�);

ALTER TABLE �������� 
ADD CONSTRAINT FK_����_�����ȣ FOREIGN KEY(�����ȣ)
REFERENCES ����(�����ȣ);

ALTER TABLE ���ǳ��� 
ADD CONSTRAINT FK_����_������ȣ FOREIGN KEY(������ȣ)
REFERENCES ����(������ȣ);

ALTER TABLE ���ǳ��� 
ADD CONSTRAINT FK_����_�����ȣ2 FOREIGN KEY(�����ȣ)
REFERENCES ����(�����ȣ);



COMMIT;


/* INNER JOIN �������� (��������) */
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
AND   ��������.�����ȣ = ����.�����ȣ 
AND �л�.�̸� = '������';

--�л��� �������� �Ǽ��� ��ȸ�Ͻÿ�(���� �Ҽ��� 2°�ڸ� ���� ǥ��,�̸�����)




SELECT �л�.�̸�
     , ROUND(�л�.����,2) as ����
     , �л�.�й� 
     , COUNT(��������.����������ȣ) as �����Ǽ�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
GROUP BY �л�.�̸�, �л�.����, �л�.�й�
ORDER BY 1 ;


/* outer join �ܺ����� null���� ���Խ�Ű�� ������*/
SELECT �л�.�̸�
     , ROUND(�л�.����,2) as ����
     , �л�.�й� 
     , COUNT(��������.����������ȣ) as �����Ǽ�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�(+) -- null�������Խ�ų �ʿ� (+)
GROUP BY �л�.�̸�, �л�.����, �л�.�й�
ORDER BY 1 ;
SELECT �л�.�̸�
     , ROUND(�л�.����,2) as ����
     , �л�.�й� 
     , ��������.����������ȣ as �����Ǽ�
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�(+) -- null�������Խ�ų �ʿ� (+)
ORDER BY 1 ;
-- �л��� ������������ �� ���������� ����Ͻÿ� 
SELECT �л�.�̸�
     , ROUND(�л�.����,2) as ����
     , �л�.�й� 
     , COUNT(��������.����������ȣ) as �����Ǽ�
     ,SUM(NVL(����.����,0)) as �Ѽ�������
FROM �л�, ��������, ����
WHERE �л�.�й� = ��������.�й�(+) 
AND   ��������.�����ȣ = ����.�����ȣ(+)
GROUP BY �л�.�̸�, ROUND(�л�.����,2), �л�.�й� 
ORDER BY 1 ;

SELECT count(*)
FROM �л�, ��������; -- cross join (�����ؾ���) 
                   -- 9 * 17 = 153
SELECT count(*)
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�;

SELECT *
FROM member;

SELECT *
FROM cart;

 --�����뾾�� 'īƮ���Ƚ��, ���Ż�ǰ ǰ�� ��, �ѱ��Ż�ǰ��
 --'�ѱ��űݾ�'�� ����Ͻÿ� 
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as īƮ���Ƚ��
     , COUNT(DISTINCT b.cart_prod) as ���Ż�ǰǰ���
     , SUM(NVL(b.cart_qty,0))    as �ѱ��ż���
FROM member a
    ,cart b
WHERE a.mem_id = b.cart_member(+)
AND a.mem_name = '������'
GROUP BY a.mem_id
       , a.mem_name;
 
--�����뾾�� 'īƮ���Ƚ��, ���Ż�ǰ ǰ�� ��, �ѱ��Ż�ǰ��
--'�ѱ��űݾ�'�� ����Ͻÿ� (��ǰ �ݾ��� prod_sale���)



 SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as īƮ���Ƚ��
     , COUNT(DISTINCT b.cart_prod) as ���Ż�ǰǰ���
     , SUM(NVL(b.cart_qty ,0))    as �ѱ��ż���
     , SUM(NVL(b.cart_qty * c.prod_sale ,0))    as �ѱ��űݾ�
FROM member a
    ,cart b
    ,prod c
WHERE a.mem_id = b.cart_member(+)
AND   b.cart_prod = c.prod_id(+)
AND a.mem_name = '������'
GROUP BY a.mem_id
       , a.mem_name;
       
-- employees, jobs ���̺��� Ȱ���Ͽ� 
-- salary�� 15000 �̻��� ������ ���, �̸�, salary, �������� ����Ͻÿ�   
SELECT employee_id
      ,emp_name
      ,salary
      ,job_id
FROM employees;
       
SELECT job_id
     , job_title
FROM jobs;

SELECT a.employee_id
      ,a.emp_name
      ,a.salary
      ,b.job_title
FROM employees a
   , jobs b 
WHERE a.job_id = b.job_id
AND a.salary >= 15000;       


       
SELECT a.employee_id   /*���*/
     , a.emp_name      /*�̸�*/
     , a.salary        /*����*/
     , b.job_title     /*������*/
FROM employees a       --�������̺�
   , jobs b            --�������̺�
WHERE a.job_id = b.job_id
AND   a.salary >= 15000;

/* subquery (�����ȿ� ����)
    1.��Į�� ��������(select ��)
    2.�ζ��� �� (from��)
    3.��ø����(where��)
*/
-- ��Į�� ���������� ������ ��ȯ
-- ������ ���� ���� �������̺��� �� �Ǽ� ��ŭ ��ȸ�ϱ⶧����(���ſ� ���̺��� ����ϸ� �����ɸ�)
-- ���Ͱ��� ��Ȳ���� ������ �̿��ϴ°� �� ����.
SELECT a.emp_name
--      ,a.department_id  -- �μ� ���̵� ��� �μ����� �ʿ��Ҷ� 
                        -- �μ����̵�� �μ����̺��� pk (����ũ�� ������ ��ȯ)
      ,(SELECT department_name 
        FROM departments
        WHERE department_id = a.department_id) as dep_nm
--      , a.job_id   -- ��Į�󼭺������� job_title�� ����Ͻÿ�.
      , (SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_nm
FROM employees a;

-- ��ø��������(where��)
-- ������ salary ��ü��� ���� ���� ������ ����Ͻÿ� 
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees) --6461.831775700934579439252336448598130841
ORDER BY 2 ;

SELECT emp_name, salary
FROM employees
WHERE salary >= 6461.831775700934579439252336448598130841
ORDER BY 2 ;


-- �л��� '��ü��� ����' �̻��� �л������� ����Ͻÿ� 
SELECT �й�, �̸�, ����, ����
FROM �л�
WHERE ���� >= ( SELECT AVG(����)
                FROM �л� )
;
-- ������ ���� ���� �л��� ������ ����Ͻÿ� 
SELECT �й�, �̸�, ����, ����
FROM �л�
WHERE ���� = ( SELECT MAX(����)
                FROM �л� )
;
-- ���� �̷��� ���� �л��� �̸��� ����Ͻÿ� 
SELECT �̸�
FROM �л�
WHERE �й� NOT IN(SELECT �й�
                  FROM ��������)
;
SELECT �̸�
FROM �л�
WHERE �й� NOT IN(2002110110,1997131542,1998131205,2001211121,1999232102,2001110131);

-- ���ÿ� 2���̻��� �÷� ���� ���� �� ��ȸ
SELECT employee_id
     , emp_name
     , job_id
FROM employees
WHERE (employee_id, job_id ) IN (SELECT employee_id, job_id
                                 FROM job_history);
                                 
                                 
--������ �� �⵵�� �������ܾ��� ���ϴ� ������ �ۼ��� ����.(kor_loan_status)




   SELECT REGION,
       SUM(CASE WHEN PERIOD LIKE '2011%' THEN LOAN_JAN_AMT ELSE 0 END)  AMT_2011,
       SUM(CASE WHEN PERIOD LIKE '2012%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2012, 
       SUM(CASE WHEN PERIOD LIKE '2013%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2013 
 FROM KOR_LOAN_STATUS
GROUP BY ROLLUP(REGION)
ORDER BY 1;




SELECT �̸�
FROM �л� 
WHERE �й� NOT IN (SELECT �й�
                   FROM ��������);
                   
-- EXISTS �����ϴ��� üũ
-- EXISTS ���������� ���̺� �˻������� �����Ͱ� �����ϸ�
-- �����ϴ� �����Ϳ� ���ؼ� ������������ ��ȸ
SELECT a.department_id
     , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
                FROM job_history b
                WHERE b.department_id = a.department_id);
                
                
                
SELECT a.department_id
     , a.department_name
FROM departments a
WHERE NOT EXISTS (SELECT 1  -- NOT EXISTS �������� �ʴ�
                FROM job_history b
                WHERE b.department_id = a.department_id);

-- �����̷��� ���� �л��� ��ȸ�Ͻÿ�
SELECT *
FROM �л� a
WHERE NOT EXISTS (SELECT *
                    FROM ��������
                    WHERE �й� = a.�й�);
                    
-- ���̺� ����
CREATE TABLE emp_temp AS
SELECT *
FROM employees;

-- UPDATE �� ��ø���� ���
-- �� ����� �޿��� ��� �ݾ����� ����
UPDATE emp_temp
SET salary = (SELECT AVG(salary)
                FROM emp_temp);
ROLLBACK;
SELECT *
FROM emp_temp;
-- ��� �޿����� ���� �޴� ��� ����
DELETE emp_temp
WHERE salary>=(SELECT AVG(salary)
            FROM emp_temp);
            
--// �̱�����ǥ����ȸ ANSI, American National Standards Institute
--FROM ���� ���������� ��
--inner join�� ǥ�� ANSI JOIN�������
SELECT a.�й�
     , a.�̸�
     , b.����������ȣ
FROM �л� a
INNER JOIN �������� b
ON(a.�й�=b.�й�);
--�������̺��߰� INNER JOIN
SELECT a.�й�
     , a.�̸�
     , b.����������ȣ
     , c.�����̸�
FROM �л� a
INNER JOIN �������� b
ON(a.�й�=b.�й�)
INNER JOIN ���� c
ON(b.�����ȣ = c.�����ȣ);

-- ANSI OUTER JOIN
-- LEFT OUTER JOIN or RIGHT OUTER JOIN
SELECT *
FROM �л� a
    ,�������� b
WHERE a.�й�=b.�й�(+); -- �Ϲ� outer join

SELECT *
FROM �л� a
LEFT OUTER JOIN
�������� b
ON (a.�й� = b.�й�);

-- �ų� ��������(Americas, Asia)�� ���Ǹűݾ��� ����Ͻÿ�
-- sales, customers, countries ���̺� ���
-- ������ country_region, �Ǹűݾ��� amount_sold
--�Ϲ� join ��� or ANSI join���
SELECT to_char(a.sales_date, 'YYYY') as years
     , c.country_region
     , SUM(a.amount_sold) �Ǹűݾ�
FROM SALES a
     ,CUSTOMERS b
     ,COUNTRIES c
WHERE a.cust_id=b.cust_id
AND b.country_id = c.country_id
AND c.country_region IN ('Americas', 'Asia')
GROUP BY to_char(a.sales_date, 'YYYY')
                ,c.country_region_id, c.country_region
ORDER BY 2;

/* MERGE (����)
    Ư�� ���ǿ� ���� ������̺� ���� INSERT or UPDATE or DELETE�� �ؾ��� �� 1���� SQL�� ó������*/
-- �������̺� �ӽŷ��� ������ ������ INSERT ����2�� �ִٸ� UPDATE ����3����
SELECT MAX(NVL(�����ȣ, 0)) + 1 FROM ����;
-- merge 1.������̺��� �� ���̺��� ���
MERGE INTO ���� a
USING DUAL --�����̺� dual�� ������̺��� �����̺��϶�
ON (a.�����̸� = '�ӽŷ���') -- MATCH����
WHEN MATCHED THEN
 UPDATE SET a.���� = 3 -- merge�� insert�� update�� ���̺� ���� ����
WHEN NOT MATCHED THEN
INSERT(a.�����ȣ, a.�����̸�, a.����)
VALUES( (SELECT MAX(NVL(�����ȣ, 0)) + 1 FROM ����) ,'�ӽŷ���', 2);

SELECT * from ����;

-- merge 2.�ٸ� ���̺� ��match������ �� ���
-- (1) ������̺��� ������ ��� 146�� �����ȣ�� ��ġ�ϴ� ������ ���ʽ��ݾ��� �޿��� 1%�� ������Ʈ
-- ����� ��ġ�ϴ°� ���ٸ� �޿��� 8000 �̸��� ����� 0.1%�� �μ�Ʈ
CREATE TABLE emp_info(
    emp_id NUMBER
    ,bonus NUMBER default 0
);
INSERT INTO emp_info(emp_id)
SELECT a.employee_id
FROM employees a
WHERE a.emp_name LIKE 'L%';
SELECT * FROM emp_info;

-- �Ŵ��� ����� 146 ������Ʈ ����
SELECT a.employee_id, a.salary * 0.01, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                    FROM emp_info);
                    
-- INSERT ����
SELECT a.employee_id, a.salary * 0.001, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                    FROM emp_info);
                    
MERGE INTO emp_info a
USING (SELECT employee_id, salary, manager_id
        FROM employees
        WHERE manager_id = 146) b
    ON(a.emp_id = b.employee_id) -- match����
WHEN MATCHED THEN
    UPDATE SET a.bonus = a.bonus + b.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT (a.emp_id, a.bonus) VALUES (b.employee_id, b.salary * 0.001)
    WHERE (b.salary <8000);
    



