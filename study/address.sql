SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM order_info;
SELECT * FROM reservation;

SELECT TO_CHAR(to_date(reserv_date),'d')
,  TO_CHAR(to_date(reserv_date),'day') FROM reservation;
-----------1�� ���� ---------------------------------------------------
--1988�� ���� ������� ������ �ǻ�,�ڿ��� ���� ����Ͻÿ� (� ������ ���)
---------------------------------------------------------------------
SELECT *
FROM customer
WHERE (job = '�ǻ�' OR job = 'ȸ���' OR job = '�ڿ���') AND (birth IS NOT NULL)
AND TO_NUMBER(SUBSTR(birth,1,4)) >=1988
ORDER BY birth DESC;




-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
---------------------------------------------------------------------

SELECT a.customer_name, a.phone_number
FROM customer a, address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '������';


----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)
---------------------------------------------------------------------
SELECT job, count(*) as cnt
FROM customer
WHERE job is not null
GROUP BY job
ORDER BY 2 DESC;


----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT * FROM (
  SELECT TO_CHAR(first_reg_date, 'DAY') AS ����, COUNT(*) AS �Ǽ�
  FROM customer
  GROUP BY TO_CHAR(first_reg_date, 'DAY')
  ORDER BY �Ǽ� DESC
)

WHERE ROWNUM = 1;
----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 
---------------------------------------------------------------------

SELECT CASE WHEN sex_code IS NULL AND grouping_id(sex_code) = 0 THEN '�̵��'
            WHEN sex_code IS NULL AND grouping_id(sex_code) = 1 THEN '�Ѱ�'
            WHEN sex_code = 'M' THEN '����'
            WHEN sex_code = 'F' THEN '����'
            END AS �μ�
     , COUNT(*) ������
FROM customer
GROUP BY ROLLUP(sex_code);



----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
---------------------------------------------------------------------
SELECT SUBSTR(reserv_date, 5, 2) AS ��, COUNT(cancel) AS ��ҰǼ�
FROM reservation
WHERE cancel = 'Y' 
GROUP BY SUBSTR(reserv_date, 5, 2)
ORDER BY ��ҰǼ� DESC;

----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
-----------------------------------------------------------------------------
SELECT a.product_name as ��ǰ�̸�, SUM(b.sales) AS ��ǰ����
FROM item a
JOIN order_info b ON a.item_id = b.item_id
GROUP BY a.product_name
ORDER BY ��ǰ���� DESC;


---------- 7�� ���� ---------------------------------------------------
-- ����ǰ�� ���� ������� ���Ͻÿ� 
-- �����, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------


SELECT SUBSTR(b.reserv_no, 1, 6) AS ��,
       SUM(CASE WHEN a.product_name = 'SPECIAL_SET' THEN b.sales ELSE 0 END) AS SPECIAL_SET,
       SUM(CASE WHEN a.product_name = 'PASTA' THEN b.sales ELSE 0 END) AS PASTA,
       SUM(CASE WHEN a.product_name = 'PIZZA' THEN b.sales ELSE 0 END) AS PIZZA,
       SUM(CASE WHEN a.product_name = 'SEA_FOOD' THEN b.sales ELSE 0 END) AS SEA_FOOD,
       SUM(CASE WHEN a.product_name = 'STEAK' THEN b.sales ELSE 0 END) AS STEAK,
       SUM(CASE WHEN a.product_name = 'SALAD_BAR' THEN b.sales ELSE 0 END) AS SALAD_BAR,
       SUM(CASE WHEN a.product_name = 'SALAD' THEN b.sales ELSE 0 END) AS SALAD,
       SUM(CASE WHEN a.product_name = 'SANDWICH' THEN b.sales ELSE 0 END) AS SANDWICH,
       SUM(CASE WHEN a.product_name = 'WINE' THEN b.sales ELSE 0 END) AS WINE,
       SUM(CASE WHEN a.product_name = 'JUICE' THEN b.sales ELSE 0 END) AS JUICE

FROM item a
JOIN order_info b ON a.item_id = b.item_id
GROUP BY SUBSTR(b.reserv_no, 1, 6)
ORDER BY ��;




---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ� 

----------------------------------------------------------------------------
SELECT �����, ��ǰ�̸�
     , SUM(DECODE(����, '�Ͽ���', sales, 0)) as �Ͽ���
     , SUM(DECODE(����, '������', sales, 0)) as ������
     , SUM(DECODE(����, 'ȭ����', sales, 0)) as ȭ����
     , SUM(DECODE(����, '������', sales, 0)) as ������
     , SUM(DECODE(����, '�����', sales, 0)) as �����
     , SUM(DECODE(����, '�ݿ���', sales, 0)) as �ݿ���
     , SUM(DECODE(����, '�����', sales, 0)) as �����  
FROM(SELECT SUBSTR(a.reserv_date,1,6) as �����
     , c.product_desc as ��ǰ�̸�
     , TO_CHAR(TO_DATE(a.reserv_date),'day') as ����
     , b.sales
        FROM reservation a
            ,order_info b
            ,item c
        WHERE a.reserv_no = b.reserv_no
        AND b.item_id = c.item_id
        AND c.product_desc = '�¶���_�����ǰ')
        GROUP BY �����, ��ǰ�̸�
        ORDER BY 1;






---------- 9�� ���� ----------------------------------------------------
--�����̷��� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
----------------------------------------------------------------------------

SELECT a.address_detail as �ּ�, a.zip_code as �����ȣ, count(distinct b.customer_id) as ī����
FROM address a
JOIN customer b ON a.zip_code = b.zip_code
JOIN reservation c ON b.customer_id = c.customer_id
GROUP BY a.address_detail, a.zip_code
ORDER BY 3 DESC;




