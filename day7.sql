SELECT gubun
     , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY ROLLUP(gubun);

-- member ������ ���ϸ����� �հ�� ��ü �Ѱ踦 ���Ͻÿ�
SELECT mem_job
     , SUM(mem_mileage) as �հ�
FROM member
GROUP BY ROLLUP(mem_job);

SELECT period
     , gubun
     , sum(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun); --period�� �Ұ�

SELECT gubun
     , period
     , sum(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(gubun, period); --gubun�� �Ұ�

--employees ���̺��� ������ �� �μ��� �������� ��ü �������� ����Ͻÿ�
SELECT department_id
     , COUNT(employee_id) ������
FROM employees
GROUP BY ROLLUP(department_id);

--employees ���̺��� ������ �� �μ��� �������� ��ü �������� ����Ͻÿ�
-- grouping_id
SELECT CASE WHEN department_id IS NULL AND grouping_id(department_id) = 0 THEN '�μ�����'
            WHEN department_id IS NULL AND grouping_id(department_id) = 1 THEN '�Ѱ�'
            ELSE TO_CHAR(department_id)
            END AS �μ�
     , COUNT(*) ������
FROM employees
GROUP BY ROLLUP(department_id);

-- ������ �̹� ������ commission_pct ��ŭ �߰����� �Ϸ��� �մϴ�.
-- ���ް�, �߰��ݾ�, �ջ�ݾ��� ����Ͻÿ�
-- NVL(����, ���氪) ������ NULL �� ��� ���氪���� ��ü
SELECT emp_name, salary ����
     , salary * NVL(commission_pct, 0) as ��
     , salary + (salary * NVL(commission_pct, 0)) as �ջ�ݾ�
FROM employees;

SELECT * FROM member;
-- member ȸ���� ���������� ȸ���� ������ �ο����� ���ϸ��� �հ� �ݾ��� ����Ͻÿ�(�Ѱ赵)
SELECT CASE WHEN mem_job IS NULL AND grouping_id(mem_job) = 1 THEN '�Ѱ�'
       ELSE TO_CHAR(mem_job)
     END AS ����
     , COUNT(*) AS ȸ����
     , SUM(mem_mileage) AS ���ϸ����հ�
FROM member
WHERE mem_add1 LIKE '%����%'
GROUP BY ROLLUP(mem_job);
-- ���� UNION(������), UNION ALL(��ü����), MINUS ������ INTERSECT ������
-- ��ȸ����� �÷����� Ÿ���� ������ ���� ���밡��(������ �������� ����)
SELECT * FROM exp_goods_asia;
SELECT seq,goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT seq,goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT 1, 'hi'
FROM dual;

SELECT mem_job
     , SUM(mem_mileage) as �հ�
FROM member
GROUP BY mem_job
UNION
SELECT '�հ�'
     , SUM(mem_mileage)
FROM member
ORDER BY 2 asc;

SELECT *
FROM member
WHERE mem_name = 'Ź����';

SELECT *
FROM cart
WHERE cart_member = 'n001';

-- INNER JOIN(��������)   (���������̶�� ��.)
SELECT member.mem_id
     , member.mem_name
     , cart.cart_member
     , cart.cart_prod
     , cart.cart_qty
FROM member, cart
WHERE member.mem_id = cart.cart_member
AND member.mem_name = '������'; -- mem_id�� cart_member ���� �����Ҷ� ����

SELECT member.mem_id
     , member.mem_name
     , SUM(cart.cart_qty) ��ǰ���ż�
FROM member, cart
WHERE member.mem_id = cart.cart_member
AND member.mem_name = '������'
GROUP BY member.mem_id, member.mem_name;
-- �ܺ�����
SELECT member.mem_id
     , member.mem_name
     , NVL(SUM(cart.cart_qty), 0) ��ǰ���ż�
FROM member, cart
WHERE member.mem_id = cart.cart_member(+) -- outer join �ܺ�����(null���� ���Խ��Ѿ� �Ҷ�(+)���
AND member.mem_name = 'Ź����'
GROUP BY member.mem_id, member.mem_name;

SELECT member.mem_id
     , member.mem_name
     , cart.cart_member
     , cart.cart_qty ��ǰ���ż�
FROM member, cart
WHERE member.mem_id = cart.cart_member(+); -- outer join �ܺ�����(null���� ���Խ��Ѿ� �Ҷ�(+)���

-- ������ �̸��� �μ����� ����Ͻÿ�
SELECT employees.emp_name
     , employees.department_id
FROM employees;
SELECT departments.department_id
     , departments.department_name
FROM departments;
/*
������ �Ҷ��� ���� �� ���̺��� �ʿ��� �÷� ��ȸ select�� �ۼ�
�� ������ �����Ͱ� �´��� Ȯ�� ��
������ �̿��� select�� �ۼ�
*/
SELECT employees.emp_name
     , departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

SELECT a.emp_name
     , b.department_name
FROM employees a, departments b --���̺� ��Ī
WHERE a.department_id = b.department_id;

-- ���ǻ���
SELECT emp_name --�� ���̺� ���ʿ��� �ִ� �÷��� ���̺���� ���� �ʾƵ� ��
     , department_name
     , a.department_id  -- �� ���̺� ������ �÷��� �ִٸ� ��� ������ ���������
FROM employees a, departments b   -- ���̺� ��Ī
WHERE a.department_id = b.department_id;

-- employees, jobs �÷��� �̿��Ͽ�
--������ ���, �̸�, �޿�, ������ ����Ͻÿ�
SELECT *
FROM employees;
SELECT *
FROM jobs;
SELECT a.employee_id
     , a.emp_name
     , a.salary
     , b.job_title
FROM employees a, jobs b
WHERE a.job_id = b.job_id
ORDER BY 1 ASC;