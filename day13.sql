/*
    ������ ����
    ����Ŭ���� �����ϰ� �ִ� ���
    ������ �����ͺ��̽��� �����ʹ� �������� �����ͷ� �����Ǿ� �ִµ�
    ������������ ������ ������ ǥ���� �� ����
    �޴�, �μ�, ���� ���� ������ ������ ���� �� ����.
*/
SELECT department_id
     , LPAD(' ',3*(LEVEL-1))  || department_name as �μ���
     , LEVEL -- (����)Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
     , parent_id
FROM departments
START WITH parent_id IS NULL    -- ��������
CONNECT BY PRIOR department_id = parent_id; --������ ��� ����Ǵ���

SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id;

-- departments ���̺� �����͸� �����Ͻÿ�
-- IT ��������ũ ���� �μ���
-- department_id: 280
-- department_name : CHATBOT�� ������ũ�� ������ 4 ������ 5���ǰ�
SELECT department_idINSERT INTO departments (department_id, department_name, parent_id)
VALUES (280, 'CHATBOT��', 230);
FROM departments;

-- 30�μ��� ��ȸ
SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
     , a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id
AND a.department_id = 30;

SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id
--ORDER BY b.department_name; -- ������ Ʈ���� ����
ORDER SIBLINGS BY b.department_name; -- Ʈ���� �����ϰ� ���� level������


SELECT department_id
     , LPAD(' ',3*(LEVEL-1))  || department_name as �μ���
     , parent_id
     , CONNECT_BY_ROOT department_name as rootNm    -- root row�� ����
     , SYS_CONNECT_BY_PATH(department_name, '|') as pathNm
     ,CONNECT_BY_ISLEAF as leafNm-- ���������1, �ڽ��� ������ 0
FROM departments
START WITH parent_id IS NULL    -- ��������
CONNECT BY PRIOR department_id = parent_id;

drop table exco;
CREATE TABLE exco(
    ���̵� number
   ,�̸� VARCHAR2(10)
    ,��å VARCHAR2(10)
  , parent_id number
);
SELECT * FROM exco;
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (1,'�̻���', '����', null);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (2, '�����', '����', 1);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (3, '������', '����', 2);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (4,'�����', '����', 3);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (6,'�̴븮', '�븮', 4);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (8,'�ֻ��', '���', 6);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (9,'�����', '���', 6);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (5, '�ڰ���', '����', 3);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (7,'��븮', '�븮', 5);
INSERT INTO exco (���̵�,�̸�, ��å, parent_id)
VALUES (10,'�ֻ��', '���', 7);

SELECT ���̵�
     , LPAD(' ',3*(LEVEL-1))  || ��å 
     , LEVEL -- (����)Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
     , parent_id
FROM exco
START WITH parent_id IS NULL    -- ��������
CONNECT BY PRIOR ���̵� = parent_id;

/*
    ���������� ���� (���� ������ ����)
    LEVEL�� ����-���ν� (CONNECT BY ���� �Բ� ���)
*/
SELECT '2013'|| LPAD(LEVEL,2,'0') as ���
FROM dual
CONNECT BY LEVEL <=12;

SELECT period as ���
     , SUM(loan_jan_amt) as �����հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT a.���
     , NVL(b.�����հ�,0) as �����հ�
FROM (SELECT '2013'|| LPAD(LEVEL,2,'0') as ���
        FROM dual
        CONNECT BY LEVEL <=12) a
            ,(SELECT period as ���
             , SUM(loan_jan_amt) as �����հ�
                 FROM kor_loan_status
                    WHERE period LIKE '2013%'
                    GROUP BY period) b
WHERE a.��� = b.���(+);

-- 202401 - 202412 SYSDATE�� �̿��Ͽ� ����Ͻÿ�
-- connect by level ���
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <=12;
-- �̹��� 1�Ϻ��� ~ ������������ ����Ͻÿ�
SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE), 'DD');

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE), 'DD');

-- member ȸ�ӿ��� ����(mem_bir)�� �̿��Ͽ� ���� ȸ������ ����Ͻÿ�(������ ��������)
SELECT TO_CHAR(mem_bir, 'MM') AS birth_month, COUNT(*) AS member_count
FROM member
GROUP BY TO_CHAR(mem_bir, 'MM')
ORDER BY birth_month;

SELECT LPAD(TO_CHAR(months.month, 'FM00'), 2, '0') AS birth_month, 
       NVL(COUNT(member.mem_bir), 0) AS member_count
FROM (
  SELECT LEVEL AS month
  FROM dual
  CONNECT BY LEVEL <= 12
) months
LEFT JOIN member
ON TO_CHAR(member.mem_bir, 'MM') = LPAD(TO_CHAR(months.month, 'FM00'), 2, '0')
GROUP BY ROLLUP(months.month)
ORDER BY birth_month;





