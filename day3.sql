/*DML INSERT ������ ����*/
-- 1. �⺻�����÷��� ����
drop table ex3_1;
CREATE TABLE ex3_1 (
     col1 VARCHAR2(100)
    ,col2 NUMBER
    ,col3 DATE
);
INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('nick', 10, SYSDATE);
-- ���ڿ�Ÿ���� '' ���ڴ� �׳� ���ڷ� ������ '10'�� �޾���
INSERT INTO ex3_1(col1,col2) --Ʋ���÷��� �����Ҷ��� ������ �÷��� �ۼ�
VALUES('judy', 9);
INSERT INTO ex3_1(col1,col2) --Ʋ���÷��� �����Ҷ��� ������ �÷��� �ۼ�
VALUES('jack', '20');
-- 2. ���̺� �ִ� ��ü �÷��� ���ؼ� �����Ҷ��� �Ƚᵵ��
INSERT INTO ex3_1 VALUES ('�ؼ�', 10, SYSDATE);
--3. select ~ insert ��ȸ����� ����
INSERT INTO ex3_1 (col1, col2)
SELECT emp_name, employee_id
FROM employees;
SELECT * FROM ex3_1;
-- �Ʒ� ��ȸ�����
SELECT * 
FROM tb_info;
-- DML :DEKETE ������ ����
DELETE ex3_1; --��ü����
DELETE ex3_1;
WHERE col1 = 'nick'; --Ư�� ������ ����
Delete dep
WHERE deptno = 3; -- emp���� �����ϰ� �־ ������ �ȵ�

SELECT *
FROM emp;
DELETE emp
WHERE empno = 200; -- dep �����ϰ� �ִ� emp������ ���� ���� �� ��������

DROP TABLE dep;
-- �������ǵ� ���� �� ���̺� ����( �����ϴ� ���̺��� �־ ������ �ȵ� ��)
DROP TABLE dep CASCADE CONSTRAINTS;

-- �ǻ��÷�(���̺��� ������ �ִ°�ó�� ���)
SELECT ROWNUM as rnum
    ,pc_no
    ,nm,
     hobby
FROM tb_info
WHERE ROWNUM <= 10;
-- �ߺ� ���� (DISTINCT)
SELECT DISTINCT cust_gender
FROM customers;
-- ǥ���� (���̺� Ư�� �������� ǥ���� �ٲٰ� ������ ���)
SELECT DISTINCT cust_name
      ,CASE WHEN cust_gender ='M' THEN '����'
            WHEN cust_gender ='F' THEN '����'
        ELSE '?'
        END as gender
FROM customers;
-- salary 10000 �̻� ��׿���, �������� ����
SELECT *
FROM employees;

SELECT DISTINCT emp_name
    , salary
    , CASE WHEN salary >= 10000 THEN '��׿���'
        ELSE '����'
        END as salary
FROM employees;

-- NULL���ǽİ� �����ǽ�(AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL; --�÷��� ���� null��
-- NULL�� �ƴѰ��� IS NOT NULL
SELECT *
FROM departments
WHERE parent_id IS NOT NULL; --�÷��� ���� NULL�� �ƴ�
-- IN ���ǽ� (������ or�� �ʿ��Ҷ�)
-- ex) 30��, 60��, 80�� �μ� ��ȸ
SELECT emp_name, department_id
FROM employees
WHERE department_id IN (30, 60, 80);
-- LIKE �˻� ���ڿ� ���ϰ˻�
SELECT *
FROM tb_info
WHERE nm LIKE '��%'; -- ������ �����ϴ� ���
--WHERE nm LIKE '%��'; ��� ������ ���
--WHERE nm LIKE '%��%' ���� ���Ե� ���
-- tb_info���� email�� 94 ���Ե� �л��� ��ȸ�Ͻÿ�

--WHERE email LIKE '%naver%;
SELECT *
FROM tb_info
WHERE email LIKE '%94%';

-- || ���ڿ� ���ϱ�
SELECT pc_no || '[' || nm || ']' as info
FROM tb_info;

/*
    oracle ������ �Լ�(�����Լ�)
    ����Ŭ �Լ��� Ư¡�� select���� ���Ǿ�� �ϱ� ������
    ������ ��ȯ���� ����
    �����Լ��� �� Ÿ�Ժ� ����� �� �ִ� �Լ��� ����.
*/
-- ���ڿ� �Լ�
-- LOWER, UPPER
SELECT LOWER('I LIKE MAC') as lowers
    ,  UPPer('i like mac') as uppers
FROM dual; --�׽�Ʈ�� �ӽ� ���̺�(sql ������ ���߱� ����)
SELECT emp_name
FROM employees
WHERE LOWER(emp_name) = LOWER('WILLIAM SMITH');

-- select�� �������
-- (1) FROM -> (2) WHERE -> (3) GROUP BY -> (4) HAVING -> (5) SELECT-> (6)ORDERBY
SELECT 'hi'
FROM employees; --���̺� �Ǽ���ŭ ��ȸ��.

-- employees ���� �̸� -> william ���յ� ������ ��� ��ȸ�Ͻÿ�
SELECT  emp_name
FROM employees
WHERE UPPER(emp_name) LIKE '%' || UPPER('william')|| '%';

-- '%WILLIAM%';
-- SUBSTR(char, pos, len) ����ڿ� char�� pos��°���� len ���̸�ŭ �ڸ�
-- pos�� 0 ���� 1�� (����Ʈ 1)
-- pos�� ������ ���� ���ڿ��� �� ������ ������ ����� ��ġ
-- len�� �����Ǹ� pos��°���� ������ ��� ���ڸ� ��ȯ
SELECT SUBSTR('ABCD EFG', 1, 4) as ex1
    ,  SUBSTR('ABCD EFG', 4) as ex2
    ,  SUBSTR('ABCD EFG', -3, 3) as ex3
FROM dual;


-- INSTR ��� ���ڿ��� ��ġ ã��
-- �Ű����� �� 4�� 2���� �ʼ� �ڿ��� ����Ʈ 1,1
-- (p1,p2,p3,p4) p1 ����ڿ�, p2 ã������, p3 ã�������ġ, p4ã�������� ���° ����
SELECT INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����') as ex1
    ,  INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',5) as ex2
    ,  INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',1,2) as ex3
    ,  INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '��') as ex4 -- ������0
FROM dual;

-- tb_info �л��� �̸��� �̸��� �ּҸ� ����Ͻÿ�
-- ��: �̸��� �ּҸ� ���̵�� �������� �и��Ͽ� ����Ͻÿ�
--      audrl3692@naver.com ->> ���̵�:audrl3692 ������: naver.com
SELECT nm, email,
  SUBSTR(email, 1, INSTR(email, '@')-1) AS ���̵�,
  SUBSTR(email, INSTR(email, '@')+1) AS ������
FROM 
  tb_info;


