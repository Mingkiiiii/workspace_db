SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM item;
SELECT * FROM order_info;
SELECT * FROM reservation;

SELECT TO_CHAR(to_date(reserv_date),'d')
,  TO_CHAR(to_date(reserv_date),'day') FROM reservation;
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
---------------------------------------------------------------------
SELECT *
FROM customer
WHERE (job = '의사' OR job = '회사원' OR job = '자영업') AND (birth IS NOT NULL)
AND TO_NUMBER(SUBSTR(birth,1,4)) >=1988
ORDER BY birth DESC;




-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------

SELECT a.customer_name, a.phone_number
FROM customer a, address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '강남구';


----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT job, count(*) as cnt
FROM customer
WHERE job is not null
GROUP BY job
ORDER BY 2 DESC;


----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
SELECT * FROM (
  SELECT TO_CHAR(first_reg_date, 'DAY') AS 요일, COUNT(*) AS 건수
  FROM customer
  GROUP BY TO_CHAR(first_reg_date, 'DAY')
  ORDER BY 건수 DESC
)

WHERE ROWNUM = 1;
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------

SELECT CASE WHEN sex_code IS NULL AND grouping_id(sex_code) = 0 THEN '미등록'
            WHEN sex_code IS NULL AND grouping_id(sex_code) = 1 THEN '총계'
            WHEN sex_code = 'M' THEN '남자'
            WHEN sex_code = 'F' THEN '여자'
            END AS 부서
     , COUNT(*) 직원수
FROM customer
GROUP BY ROLLUP(sex_code);



----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
SELECT SUBSTR(reserv_date, 5, 2) AS 월, COUNT(cancel) AS 취소건수
FROM reservation
WHERE cancel = 'Y' 
GROUP BY SUBSTR(reserv_date, 5, 2)
ORDER BY 취소건수 DESC;

----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT a.product_name as 상품이름, SUM(b.sales) AS 상품매출
FROM item a
JOIN order_info b ON a.item_id = b.item_id
GROUP BY a.product_name
ORDER BY 상품매출 DESC;


---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------


SELECT SUBSTR(b.reserv_no, 1, 6) AS 월,
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
ORDER BY 월;




---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 

----------------------------------------------------------------------------
SELECT 매출월, 상품이름
     , SUM(DECODE(요일, '일요일', sales, 0)) as 일요일
     , SUM(DECODE(요일, '월요일', sales, 0)) as 월요일
     , SUM(DECODE(요일, '화요일', sales, 0)) as 화요일
     , SUM(DECODE(요일, '수요일', sales, 0)) as 수요일
     , SUM(DECODE(요일, '목요일', sales, 0)) as 목요일
     , SUM(DECODE(요일, '금요일', sales, 0)) as 금요일
     , SUM(DECODE(요일, '토요일', sales, 0)) as 토요일  
FROM(SELECT SUBSTR(a.reserv_date,1,6) as 매출월
     , c.product_desc as 상품이름
     , TO_CHAR(TO_DATE(a.reserv_date),'day') as 요일
     , b.sales
        FROM reservation a
            ,order_info b
            ,item c
        WHERE a.reserv_no = b.reserv_no
        AND b.item_id = c.item_id
        AND c.product_desc = '온라인_전용상품')
        GROUP BY 매출월, 상품이름
        ORDER BY 1;






---------- 9번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------

SELECT a.address_detail as 주소, a.zip_code as 우편번호, count(distinct b.customer_id) as 카운팅
FROM address a
JOIN customer b ON a.zip_code = b.zip_code
JOIN reservation c ON b.customer_id = c.customer_id
GROUP BY a.address_detail, a.zip_code
ORDER BY 3 DESC;




