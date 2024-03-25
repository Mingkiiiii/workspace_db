/*
    WITH�� : ��Ī���� ����� SELECT ���� �ٸ� SELECT ������ ��Ī���� ��������
            - �ݺ��Ǵ� ���������� �ִٸ� ����ó�� �ѹ� �ҷ��ͼ� ���
            - ������ ��������� ���̺��� ž���� �� ���� ���
        temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� �����س���
        �����س��� �����͸� �������ϱ� ������ ������ ���� �� ����
*/
WITH A AS(  --��Ī
        SELECT *
        FROM employees
)
SELECT *
FROM A;

--- 8~14�ڸ�, �빮��1, �ҹ���1, Ư������1 ���� �׽�Ʈ
WITH test_data AS(
    SELECT 'abcd' AS pw FROM dual UNION ALL
    SELECT 'abcd!A' AS pw FROM dual UNION ALL
    SELECT 'abcdasdfas' AS pw FROM dual UNION ALL
    SELECT 'abcd!1Ad' AS pw FROM dual
)
SELECT pw
FROM test_data
WHERE LENGTH(pw) BETWEEN 8 AND 14
AND REGEXP_LIKE(pw, '[A-Z]')
AND REGEXP_LIKE(pw, '[a-z]')
AND REGEXP_LIKE(pw, '[a-zA-Z0-9��-�R]');
-- ���� īƮ ���Ƚ���� ���� ���� ���� �������� ���� ������ ����Ͻÿ�
-- (�����̷��� �ִ� ����)
SELECT MAX(cnt) as max_cnt
     , MIN(cnt) as min_cnt
FROM(
SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
FROM member a
    , cart b
WHERE a.mem_id = b.cart_member
GROUP BY a.mem_id, a.mem_name);


SELECT *
FROM ( SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
            FROM member a
                , cart b
            WHERE a.mem_id = b.cart_member
            GROUP BY a.mem_id, a.mem_name)
            WHERE cnt = (SELECT MAX(cnt) as max_cnt
FROM(
        SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a
            , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name))
        OR cnt = (SELECT MIN(cnt) as min_cnt
FROM(
        SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a
            , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name));



-- ���� ���� (WITH��)
WITH T1 AS (SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name
), T2 AS ( SELECT MAX(T1.cnt) as max_cnt, MIN(t1.cnt) as min_cnt
        FROM T1
)
SELECT t1.mem_id, t1.mem_name FROM t1, t2
WHERE t1.cnt = t2.max_cnt
OR t1.cnt = t2.min_cnt;

/*  2000�⵵ ��Ż������ '����� �����' ���� ū '���� ��� �����'
    �̾��� '���', '�����'�� ����Ͻÿ�  (�Ҽ��� �ݿø�)
*/
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
-- �����
SELECT ROUND(AVG(a.amount_sold)) as year_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND a.sales_month LIKE '2000%'
AND c.country_name = 'Italy';
-- �����
SELECT a.sales_month,ROUND(AVG(a.amount_sold)) as month_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND a.sales_month LIKE '2000%'
AND c.country_name = 'Italy'
GROUP BY a.sales_month;

SELECT *
    FROM (SELECT a.sales_month,ROUND(AVG(a.amount_sold)) as month_avg
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND a.sales_month LIKE '2000%'
            AND c.country_name = 'Italy'
            GROUP BY a.sales_month
)
WHERE month_avg > (SELECT ROUND(AVG(a.amount_sold)) as year_avg
                        FROM sales a, customers b, countries c
                        WHERE a.cust_id = b.cust_id
                        AND b.country_id = c.country_id
                        AND a.sales_month LIKE '2000%'
                        AND c.country_name = 'Italy');

-----------------------
WITH T1 as (SELECT a.sales_month,a.amount_sold
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND a.sales_month LIKE '2000%'
            AND c.country_name = 'Italy'
)
, T2 as ( SELECT AVG(t1.amount_sold) as year_avg
            FROM t1
)
, T3 as (SELECT t1.sales_month
                ,ROUND(AVG(t1.amount_sold)) as month_avg
                FROM t1
                GROUP BY t1.sales_month
)
SELECT t3.sales_month, t3.month_avg
FROM t2, t3 WHERE t3.month_avg > t2.year_avg;

/* �м��Լ� �ο�ս� ���� ���԰��� ���� �� �� ����
   ���� ���� or �ο������������ �κ����踦 �� �� ����
   (ex ���� �����հ�)
   �м��Լ� :AVG, SUM, MAX, MIN, COUNT, DENSE_RANK, RANK, LAG...
   PARTITION BY : �׷�
   ORDER BY : ���� ����
   WINDOW : �׷�ȿ� ���� �׷����� ���� �� ��
*/
-- ROW_NUMBER �׷캰 �ο쿡 ���� ������ȯ
SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY emp_name) dep_rownum
FROM employees;

-- �μ��� �̸������� ���� ù��° ������ ����Ͻÿ�
SELECT *
FROM(
SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY emp_name) dep_rownum
FROM employees)
WHERE dep_rownum = 1;

-- rank ���� ���� ������ �ǳʶ�
-- dense_rank �ǳʶ�������
SELECT department_id, emp_name, salary
     , RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as rnk
     , DENSE_RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as dense_rnk
FROM employees;

-- �л����� ������ ������ ����(��������)���� ������ ����Ͻÿ�
SELECT �̸�, ����, ����
     , RANK() OVER(PARTITION BY ����
                    ORDER BY ���� DESC) as ����
     , RANK() OVER(
                    ORDER BY ���� DESC) as ��ü����
FROM �л�;


--------------------------------------------------------------------
SELECT emp_name, salary, department_id
     , SUM(salary) OVER (PARTITION BY department_id) as �μ��հ�
     , SUM(salary) OVER () as ��ü�հ�
FROM employees;

-- ������ �л����� �������� ������ ���Ͻÿ�(�л��� ������������)
SELECT ����, COUNT(*) as �л���,
       RANK() OVER (ORDER BY COUNT(*) DESC) as ����
FROM �л�
GROUP BY ����;

-- ��ǰ�� ���Ǹűݾ��հ�� ������ ����Ͻÿ�
-- ���� 10�� ��ǰ��, �հ�, ���� ��� (cart, prod) ���̺� Ȱ��
SELECT *
FROM(SELECT 
    a.prod_id, 
    a.prod_name, 
    SUM(a.prod_sale * b.cart_qty) AS �հ�,
    RANK() OVER (ORDER BY SUM(a.prod_sale * b.cart_qty) DESC) AS rank
FROM 
    prod a
JOIN 
    cart b ON a.prod_id = b.cart_prod
GROUP BY 
    a.prod_id, a.prod_name
ORDER BY 
    �հ� DESC)
WHERE rank<=10;

-- NTILE(expr) ��Ƽ�Ǻ��� expr�� ��õ� ����ŭ ����
-- NTILE(3) 1 ~ 3 ���� ���� ��ȯ �����ϴ� ���� ��Ŷ ����� ��
-- �ο��� �Ǽ����� ū ���� ����ϸ� ��ȯ�Ǵ� ���� ���õ�.
SELECT emp_name, department_id
     , NTILE(3) OVER(PARTITION BY department_id
                        ORDER BY salary) as nt
FROM employees
WHERE department_id IN (30, 60);
/*  LAG���� �ο��� ���� �����ͼ� ��ȯ
    LEAD ���� �ο��� ���� �����ͼ� ��ȯ
    �־��� �׷�� ������ ���� �ο쿡 �ִ� Ư�� �÷��� ���� ������ �� ���
*/
SELECT emp_name, department_id, salary
     , LAG(emp_name, 1, '�������') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as lag
     , LEAD(emp_name, 1, '���峷��') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as leads
FROM employees
WHERE department_id IN (30, 60);

-- �������� �� �л��� �������� �Ѵܰ� �ٷ� ���� �л����� �������̸� ����Ͻÿ�
SELECT �̸�, ����, ����
     , LAG(�̸�, 1, '1��') OVER(PARTITION BY ����
                                        ORDER BY ���� DESC) as lag
     , LAG(����, 1, ����) OVER(PARTITION BY ���� ORDER BY ���� DESC)- ���� as ��������
FROM �л�
GROUP BY �̸�,����, ����;

/* kor_loan_status ���̺� �ִ� �����͸� �̿��Ͽ�
    '������' '������' ���� ���� ������ ���� ���ÿ� �ܾ��� ���Ͻÿ�
    (1) �⵵���� �������� �����Ͱ� �ٸ�, 2011�� 12��,2012���� 12��, 2013�� 11�� ..
        - ������ ����ū ���� ����
    (2) ������ �������� ������� ���� �ܾ��� ���� ū �ݾ��� ����
        - 1���� �����Ͽ� ���� ū �ܾ� ����.
    (3) ����, ������ �����ܾװ� (2) ����� ���� �ݾ��� �������� ���
        - 2�� �����ؼ� �� �ݾ��� ���� ���� ���ÿ� �ܾ� ���
*/
SELECT * FROM kor_loan_status;

WITH max_loan AS (
    SELECT period, region, loan_jan_amt,
           RANK() OVER(PARTITION BY period ORDER BY period DESC, loan_jan_amt DESC) as rank
    FROM kor_loan_status
)
SELECT period, region, loan_jan_amt
FROM max_loan
WHERE rank = 1;


